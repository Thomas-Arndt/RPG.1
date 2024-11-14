extends Area2D
class_name HurtBox

var invincible = false setget set_invincible
var is_red : bool = false

const hit_effect_red = preload("res://Effects/ItemEffects/WeaponEffects/HitEffectRed.tscn")
const hit_effect_green = preload("res://Effects/ItemEffects/WeaponEffects/HitEffectGreen.tscn")

onready var timer = $Timer
onready var collision_shape = $CollisionShape2D

signal invincible_start
signal invincible_end

func set_invincible(value):
	invincible = value
	if invincible:
		emit_signal("invincible_start")
	else:
		emit_signal("invincible_end")

func start_invincible(duration):
	self.invincible = true
	timer.start(duration)
	
func create_hit_effect():
	var effect = null
	if is_red:
		effect = hit_effect_red.instance()
	else:
		effect = hit_effect_green.instance()
	assert(effect)
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func _on_Timer_timeout():
	self.invincible = false

func _on_HurtBox_invincible_start():
	collision_shape.set_deferred("disabled", true)

func _on_HurtBox_invincible_end():
	collision_shape.set_deferred("disabled", false)
