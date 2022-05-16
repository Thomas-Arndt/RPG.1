extends Area2D

onready var timer = $Timer

var duration = 1.0
var player = null

signal explosion_attack

func can_see_player():
	return player != null

func _on_AttackRadius_body_entered(body):
	player = body
	timer.start(duration)

func _on_AttackRadius_body_exited(body):
	player = null


func _on_Timer_timeout():
	if player != null:
		emit_signal("explosion_attack")
