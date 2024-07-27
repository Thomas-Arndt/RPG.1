extends KinematicBody2D

signal died(node)


export var ACCELERATION = 200
export var MAX_SPEED = 50
export var FRICTION = 2000
export var throw_height = 20

onready var timer = $Timer
onready var tween = $Tween
onready var sprite = $AnimatedSprite
onready var shadow = $ShadowSprite
onready var blink_animation_player = $BlinkAnimationPlayer
onready var stats = $Stats
onready var hurt_box = $HurtBox

const DeathEffect : String = "res://Effects/EnemyEffects/SmokeDeathEffect.tscn"

enum {
	IDLE,
	CHASE,
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = IDLE
var player = null

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	assert(player)
	timer.start(1)
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION / 6 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		CHASE:
			if is_instance_valid(player):
				hop(player.global_position, delta)
			
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, FRICTION * delta)

func hop(destination, delta):
	accelerate_towards_point(destination, delta)

func animate_arc(progress):
	var sprite_height = (throw_height * pow(sin(progress * PI), 0.7))+9
	var shadow_scale = 1.0 - sprite_height / throw_height * 0.5
	sprite.position.y = -sprite_height
	shadow.scale = Vector2(shadow_scale, shadow_scale)

func _on_Timer_timeout():
	tween.interpolate_method(self, "animate_arc", 0, 1, 0.35, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	state = CHASE

func _on_Tween_tween_all_completed():
	state = IDLE
	timer.start(1)	

func _on_Stats_no_health():
	emit_signal("died", self)
	destroy()

func destroy():
	queue_free()
	var death_fx = ResourceLoader.load(DeathEffect)
	var death_effect = death_fx.instance()
	get_parent().add_child(death_effect)
	death_effect.global_position = Vector2(global_position.x, global_position.y-12)


func _on_HurtBox_invincible_end():
	blink_animation_player.play("stop")


func _on_HurtBox_invincible_start():
	blink_animation_player.play("start")


func _on_HurtBox_area_entered(area):
	stats.change_health(-area.damage)
	knockback = area.knockback_vector * 130
	hurt_box.start_invincible(0.4)

