extends Area2D

signal is_colliding(target)

var target : Node = null

func has_target():
	return target != null

func reset_target():
	target = null

func _on_PushDetectionZone_body_entered(body):
	target = body
	emit_signal("is_colliding", target)


func _on_PushDetectionZone_body_exited(body):
	target = null
