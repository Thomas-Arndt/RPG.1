extends Area2D

class_name SceneLink

export (PackedScene) var destination_reference = null
export (Vector2) var exit_location = Vector2.ZERO
export (Vector2) var exit_direction = Vector2.DOWN

func _on_SceneLink_body_entered(body):
	WorldStats.player_spawn_vector = exit_location
	WorldStats.player_spawn_direction = exit_direction
	if destination_reference != null:
		SignalBus.emit_signal("scene_link_entered", destination_reference)
	else:
		SignalBus.emit_signal("scene_exited")
