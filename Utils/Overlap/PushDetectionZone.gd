extends Area2D

signal is_colliding(target)

onready var forward_detector = $DetectorPivot/ForwardDetector

var target : Node = null
var forward_target : Node = null

func has_target():
	return target != null

func reset_target():
	target = null

func _on_PushDetectionZone_body_entered(body):
	target = body
	if target == forward_target:
		emit_signal("is_colliding", target)


func _on_PushDetectionZone_body_exited(body):
	target = null


func _on_ForwardDetector_body_entered(body):
	forward_target = body


func _on_ForwardDetector_body_exited(body):
	forward_target = null
