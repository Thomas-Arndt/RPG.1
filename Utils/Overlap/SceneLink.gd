extends Area2D

export (String) var destination_resource_path = null
export (Vector2) var exit_location = Vector2.ZERO
export (Vector2) var exit_direction = Vector2.DOWN

func _on_Area2D_body_entered(body):
	if destination_resource_path != null:
		WorldStats.player_spawn_vector = exit_location
		WorldStats.player_spawn_direction = exit_direction
		get_tree().change_scene(destination_resource_path)
