extends KinematicBody2D
class_name VoidMote

signal finished

export var ACCELERATION = 200
export var MAX_SPEED = 50
export var FRICTION = 2000
export var throw_height = 20

onready var tween = $Tween
onready var sprite = $AnimatedSprite
onready var shadow = $ShadowSprite
onready var wander_controller = $WanderController
onready var timer = $Timer

enum {
	IDLE,
	HOP,
}

const DeathEffect : String = "res://Effects/EnemyEffects/SmokeDeathEffect.tscn"

var velocity = Vector2.ZERO
var target_position = Vector2.ZERO
var min_jumps = 3
var max_jumps = 7
var jumps = 5

var state = HOP

func _ready():
	randomize()
	jumps = randi()%(max_jumps-min_jumps) + min_jumps

func _physics_process(delta):
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		HOP:	
			accelerate_towards_point(target_position, delta)
			
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, FRICTION * delta)

func animate_arc(progress):
	var sprite_height = (throw_height * pow(sin(progress * PI), 0.7))+9
	var shadow_scale = 1.0 - sprite_height / throw_height * 0.5
	sprite.position.y = -sprite_height
	shadow.scale = Vector2(shadow_scale, shadow_scale)

func _on_Timer_timeout():
	jumps -= 1
	if jumps == 0:
		destroy()
	else:
		var target_vector = Vector2(rand_range(-50, 50), rand_range(-50, 50))
		target_position = global_position + target_vector
		tween.interpolate_method(self, "animate_arc", 0, 1, 0.35, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()
		state = HOP

func _on_Tween_tween_all_completed():
	state = IDLE
	timer.start(1)	

func throw(destination):
	tween.interpolate_property(self, "global_position", global_position, destination, 0.35, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_method(self, "animate_arc", 0, 1, 0.35, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	
func destroy():
	queue_free()
	var death_fx = ResourceLoader.load(DeathEffect)
	var death_effect = death_fx.instance()
	get_parent().add_child(death_effect)
	death_effect.global_position = Vector2(global_position.x, global_position.y-12)
