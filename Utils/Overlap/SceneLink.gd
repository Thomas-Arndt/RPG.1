extends Area2D

class_name SceneLink

export (PackedScene) var destination_reference = null
export (Vector2) var exit_location = Vector2.ZERO
export (Vector2) var exit_direction = Vector2.DOWN
export (NodePath) var paired_object = null

var active: bool = true

func _ready():
	if paired_object != null:
		get_node(paired_object).connect("set_Scene_Link_Active", self, "_on_Update_Visibility_State")

func _on_SceneLink_body_entered(body):
	if active:
		WorldStats.player_spawn_vector = exit_location
		WorldStats.player_spawn_direction = exit_direction
		if destination_reference != null:
			SignalBus.emit_signal("scene_link_entered", destination_reference, self)
		else:
			SignalBus.emit_signal("scene_exited")

func _on_Update_Visibility_State(state):
	if state == true:
		active = true
	elif state == false:
		active = false
