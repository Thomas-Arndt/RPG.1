extends KinematicBody2D

onready var sprite = $Sprite

var velocity : Vector2 = Vector2.ZERO
var speed : float = 100.0

var collision_effect : String = "res://Effects/EnemyEffects/VoidBlob/GreenVoidBlobDeathEffect.tscn"

func _physics_process(delta):
	velocity = move_and_slide(velocity)
	if get_slide_count() > 0:
		velocity = Vector2.ZERO
		queue_free()
		deploy_collision_effect()

func deploy_collision_effect():
	var death_fx = ResourceLoader.load(collision_effect)
	var effect = death_fx.instance()
	get_parent().add_child(effect)
	effect.global_position = Vector2(global_position.x, global_position.y-12)
