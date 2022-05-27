extends Area2D

var target = null;

func can_interact():
	return target != null


func _on_DetectionZone_body_entered(body):
	target = body


func _on_DetectionZone_body_exited(body):
	target = null
