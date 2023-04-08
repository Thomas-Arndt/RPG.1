extends Area2D

var player = null

func can_see_player():
	return player != null

func _on_PlayerDetectionZone_body_entered(body):
	player = body
	emit_signal("body_entered")

func _on_PlayerDetectionZone_body_exited(body):
	player = null
