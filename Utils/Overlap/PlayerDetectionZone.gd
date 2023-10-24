extends Area2D

signal player_detected(player)

var player = null

func can_see_player():
	return player != null

func _on_PlayerDetectionZone_body_entered(body):
	player = body
	emit_signal("player_detected", body)

func _on_PlayerDetectionZone_body_exited(body):
	player = null
