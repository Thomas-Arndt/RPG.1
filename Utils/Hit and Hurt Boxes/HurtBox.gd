extends Area2D

var invincible = false setget set_invincible

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

func _on_Timer_timeout():
	self.invincible = false

func _on_HurtBox_invincible_start():
	collision_shape.set_deferred("disabled", true)

func _on_HurtBox_invincible_end():
	collision_shape.set_deferred("disabled", false)
