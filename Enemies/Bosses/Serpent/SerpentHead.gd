extends KinematicBody2D

signal died

export var ACCELERATION = 500
export var MAX_SPEED = 130
export var FRICTION = 3000


onready var red_sprite_full : Node = $RedSpriteFull
onready var red_sprite_half : Node = $RedSpriteHalf
onready var green_sprite_full : Node = $GreenSpriteFull
onready var green_sprite_half : Node = $GreenSpriteHalf
onready var stats : Node = $Stats
onready var hurt_box : Node = $HurtBox
onready var blink_anim_player : Node = $BlinkAnimationPlayer
onready var wander_controller : Node = $SerpentStampedeController
onready var timer = $Timer

const segment = preload("res://Enemies/Bosses/Serpent/SerpentSegment.tscn")
const mote_barrage = preload("res://Enemies/Attacks/VoidMoteBarrage.tscn")

var DeathEffect : String = "res://Effects/EnemyEffects/VoidBlob/GreenVoidBlobDeathEffect.tscn"
var velocity = Vector2.ZERO
var knockback : Vector2 = Vector2.ZERO
var barrier_gate: String
var segments : int = 0
var next_segment : Node = null
var runner : Node = self

enum states {
	STAMPEDE,
	FRAGMENT,
	HOLD,
}
var state = states.HOLD

func _ready():
	match_dimension(WorldStats.Dimensions.Red)
	if next_segment != null:
				next_segment.follow_the_leader()

func _physics_process(delta):
	wander_controller.set_position(wander_controller.start_position)
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION / 6 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		states.STAMPEDE:
			accelerate_towards_point(wander_controller.target_position, delta)
			if wander_controller.can_see_unit():
				wander_controller.target_position = global_position
				velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
				wander_controller.update_target_position()
			move()
			
		states.FRAGMENT:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION / 6 * delta)			
			move()
			if timer.time_left < 0.5:
				open_barrier_gate()
		states.HOLD:
			pass

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, FRICTION * delta)
	
func move():
	velocity = move_and_slide(velocity)
	flip_sprites()
	
func flip_sprites():
	red_sprite_full.flip_h = velocity.x > 0
	red_sprite_half.flip_h = velocity.x > 0
	green_sprite_full.flip_h = velocity.x > 0
	green_sprite_half.flip_h = velocity.x > 0

func _on_HurtBox_area_entered(area):
	stats.change_health(-area.damage)
	hurt_box.create_hit_effect()
	hurt_box.start_invincible(0.6)

func _on_HurtBox_invincible_start():
	blink_anim_player.play("start")

func _on_HurtBox_invincible_end():
	blink_anim_player.play("stop")

func _on_Stats_no_health():
	emit_signal("died")
	queue_free()

func build_serpent():
	runner = self
	var count = 0
	while count < segments:
		count+=1
		var new_segment = segment.instance()
		new_segment.position = Vector2(runner.position.x + 30, runner.position.y)
		new_segment.previous_segment = runner
		runner.next_segment = new_segment
		get_parent().add_child(new_segment)
		runner = new_segment

func is_head():
	return true

func collide_with_barrier(gate):
	if state == states.STAMPEDE:
		barrier_gate = gate
		knockback = Vector2.DOWN * 130
		match_dimension(WorldStats.Dimensions.Green)
		var barrage = mote_barrage.instance()
		get_tree().get_nodes_in_group("MoteContainer")[0].add_child(barrage)
		barrage.global_position = global_position
		barrage.semicircle_simultaneous(6, -90)
		segment_fragment(next_segment)
		timer.start(5)
		state = states.FRAGMENT

func segment_fragment(segment):
	if segment != null:
		var fragment_direction = Vector2(rand_range(-100, 100), rand_range(-100, 100)).normalized()
		segment.knockback = fragment_direction * 130
		segment.match_dimension(WorldStats.Dimensions.Green)
		segment.fragment()
		if segment.next_segment != null:
			segment_fragment(segment.next_segment)

func set_segment_dimension(segment, dimension):
	if segment != null:
		segment.match_dimension(dimension)
		if segment.next_segment != null:
			set_segment_dimension(segment.next_segment, dimension)
			
func match_dimension(state):
	red_sprite_full.visible = false
	red_sprite_half.visible = false
	green_sprite_full.visible = false
	green_sprite_half.visible = false
	if state == WorldStats.Dimensions.Red:
		red_sprite_half.visible = true
		hurt_box.monitorable = false
		hurt_box.monitoring = false
		DeathEffect = "res://Effects/EnemyEffects/VoidBlob/RedVoidBlobDeathEffect.tscn"
	elif state == WorldStats.Dimensions.Green:
		green_sprite_full.visible = true
		hurt_box.monitorable = true
		hurt_box.monitoring = true
		DeathEffect = "res://Effects/EnemyEffects/VoidBlob/GreenVoidBlobDeathEffect.tscn"

func _on_Timer_timeout():
	match_dimension(WorldStats.Dimensions.Red)
	set_segment_dimension(next_segment, WorldStats.Dimensions.Red)
	if next_segment != null:
		next_segment.follow_the_leader()
	state = states.STAMPEDE

func open_barrier_gate():
	var door_controller = get_tree().get_nodes_in_group("SerpentStampedeDoorController")[0]
	door_controller.open_doors.append(barrier_gate)
	SignalBus.emit_signal("event_switch", barrier_gate, "open")
