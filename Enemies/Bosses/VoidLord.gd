extends KinematicBody2D
class_name VoidLord

export var ACCELERATION = 200
export var MAX_SPEED = 100
export var FRICTION = 200
export var ATK_RADIUS = 40
export var spawn_with_cutscene = false
export (PackedScene) var VoidMote = null

export (bool) var is_red = true

enum {
	IDLE,
	MOVE,
	EXPLODE,
}

var void_mote_barrage = preload("res://Enemies/Bosses/VoidMoteBarrage.tscn")
var velocity: Vector2 = Vector2.ZERO
var state = IDLE
var state_machine_paused = false

onready var anim_player = $AnimationPlayer
onready var blink_anim_player = $BlinkAnimationPlayer
onready var hurt_box = $HurtBox
onready var stats = $Stats
onready var wander_controller = $DetectionWanderController
onready var red_sprite_full = $RedSpriteFull
onready var red_sprite_half = $RedSpriteHalf
onready var green_sprite_full = $GrenSpriteFull
onready var green_sprite_half = $GreenSpriteHalf

func _ready():
	match_dimension(WorldStats.DIMENSION)
	WorldStats.connect("dimension_shift", self, "match_dimension")
	if spawn_with_cutscene:
		self.visible = false
		state_machine_pause()
	anim_player.play("idle")

func _physics_process(delta):
	
	if !state_machine_paused:
		match state:
			IDLE:
				if wander_controller.get_time_left() == 0:
					state = MOVE
					anim_player.play("walk")
			MOVE:
				accelerate_towards_point(wander_controller.target_position, delta)
				wander_controller.set_position(wander_controller.start_position)
				if wander_controller.can_see_unit():
					wander_controller.target_position = global_position
					velocity = Vector2.ZERO
					anim_player.stop()
					state = EXPLODE
			EXPLODE:
				anim_player.queue("explode")
				anim_player.queue("exploding")
				anim_player.queue("implode")
	

	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, FRICTION * delta)
	flip_sprite()

func match_dimension(state):
	red_sprite_full.visible = false
	red_sprite_half.visible = false
	green_sprite_full.visible = false
	green_sprite_half.visible = false
	hurt_box.monitorable = false
	hurt_box.monitoring = false
	
	if state == true and is_red:
		red_sprite_full.visible = true
		hurt_box.monitorable = true
		hurt_box.monitoring = true
	elif state == false and is_red:
		red_sprite_half.visible = true
	elif state == true and not is_red:
		green_sprite_half.visible = true
	elif state == false and not is_red:
		green_sprite_full.visible = true
		hurt_box.monitorable = true
		hurt_box.monitoring = true

func flip_sprite(delta_x = null):
	if delta_x != null:
		red_sprite_full.flip_h = delta_x > 0
		red_sprite_half.flip_h = delta_x > 0
		green_sprite_full.flip_h = delta_x > 0
		green_sprite_half.flip_h = delta_x > 0
	elif velocity.x != 0:
		red_sprite_full.flip_h = velocity.x > 0
		red_sprite_half.flip_h = velocity.x > 0
		green_sprite_full.flip_h = velocity.x > 0
		green_sprite_half.flip_h = velocity.x > 0
	
func _on_HurtBox_invincible_start():
	blink_anim_player.play("start")


func _on_HurtBox_invincible_end():
	blink_anim_player.play("stop")


func _on_HurtBox_area_entered(area):
	stats.change_health(-area.damage)
	hurt_box.start_invincible(0.6)

func void_circle():
	var circle = void_mote_barrage.instance()
	circle.global_position = global_position
	get_parent().add_child(circle)
	circle.circle(7)
	
func _on_explosion_animation_finished():
	wander_controller.start_timer(3)
	state = IDLE
	anim_player.play("idle")

func _on_Stats_no_health():
	queue_free()

func state_machine_pause():
	state_machine_paused = true

func state_machine_run():
	state_machine_paused = false
	state = IDLE
