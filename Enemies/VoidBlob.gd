extends KinematicBody2D

export var ACCELERATION = 200
export var MAX_SPEED = 50
export var FRICTION = 200

enum {
	IDLE,
	WANDER
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = IDLE

onready var stats = $Stats
onready var full_sprite = $FullSprite
onready var half_sprite = $HalfSprite
onready var anim_player = $AnimationPlayer
onready var hurt_box = $HurtBox

func _ready():
	stats.set_max_health(3)
	stats.set_health(3)
	state = pick_random_state([IDLE, WANDER])
	
func _physics_process(delta):
	match_dimension()
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	state = IDLE
	anim_player.play("idle")
	


func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_HurtBox_area_entered(area):
	stats.change_health(-area.damage)
	knockback = area.knockback_vector * 130
	hurt_box.start_invincible(0.4)

func _on_Stats_no_health():
	queue_free()

func match_dimension():
	pass
