extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 130
export var FRICTION = 3000

onready var red_sprite_full : Node = $RedSpriteFull
onready var red_sprite_half : Node = $RedSpriteHalf
onready var green_sprite_full : Node = $GreenSpriteFull
onready var green_sprite_half : Node = $GreenSpriteHalf
onready var anim_player : Node = $AnimationPlayer
onready var blink_anim_player : Node = $BlinkAnimationPlayer
onready var stats : Node = $Stats
onready var hurt_box : Node = $HurtBox
onready var mote_thrower : Node = $VoidMoteThrower

var DeathEffect : String = "res://Effects/EnemyEffects/VoidBlob/GreenVoidBlobDeathEffect.tscn"

enum states {
	FOLLOW,
	FRAGMENT,
}

var state = states.FOLLOW
var previous_segment : Node = null
var next_segment : Node = null
var velocity = Vector2.ZERO
var knockback : Vector2 = Vector2.ZERO
var fragment_location: Vector2

func _ready():
	match_dimension(WorldStats.Dimensions.Red)
	anim_player.play("move")
	
func _process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION / 5 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		states.FOLLOW:
			var distance_to_leader = global_position.distance_to(previous_segment.global_position)
			var follow_vector = global_position.direction_to(previous_segment.global_position)
			follow_vector = follow_vector.normalized()
			if previous_segment.is_head() and distance_to_leader <= 22:
				velocity = velocity.move_toward(follow_vector * 50, ACCELERATION * delta)
			elif not previous_segment.is_head() and distance_to_leader <= 22:
				velocity = velocity.move_toward(follow_vector * 50, ACCELERATION * delta)
			else:
				velocity = velocity.move_toward(follow_vector * MAX_SPEED, ACCELERATION * delta)
			flip_sprites()
		states.FRAGMENT:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION / 5 * delta)
			
	velocity = move_and_slide(velocity)

func follow_the_leader():
	state = states.FOLLOW
	if next_segment != null:
		next_segment.follow_the_leader()

func is_head():
	return false

func flip_sprites():
	red_sprite_full.flip_h = velocity.x > 0
	red_sprite_half.flip_h = velocity.x > 0
	green_sprite_full.flip_h = velocity.x > 0
	green_sprite_half.flip_h = velocity.x > 0


func _on_HurtBox_area_entered(area):
	stats.change_health(-area.damage)
	area.set_knockback_vector(self) 
	knockback = area.knockback_vector * 130
	move_and_slide(knockback)
	hurt_box.start_invincible(0.6)

func _on_HurtBox_invincible_start():
	blink_anim_player.play("start")


func _on_HurtBox_invincible_end():
	blink_anim_player.play("stop")


func _on_Stats_no_health():
	previous_segment.next_segment = next_segment
	if next_segment != null:
		next_segment.previous_segment = previous_segment
	die()
	
func die():
	queue_free()
	var death_fx = ResourceLoader.load(DeathEffect)
	var death_effect = death_fx.instance()
	get_parent().add_child(death_effect)
	death_effect.global_position = Vector2(global_position.x, global_position.y-12)
	
func fragment():
	mote_thrower.set_active(false)
	state = states.FRAGMENT
	if next_segment != null:
		next_segment.fragment()

func entered_arena():
	mote_thrower.set_active(true)
	mote_thrower.start_timer(rand_range(0.25, 2))

func exited_arena():
	mote_thrower.set_active(false)

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
