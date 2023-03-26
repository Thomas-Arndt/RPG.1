extends StaticBody2D

export var destination_reference : String
export var exit_location : Vector2 = Vector2.ZERO
export var exit_direction : Vector2 = Vector2.DOWN

onready var scene_link = $SceneLink

func _ready():
	assert(destination_reference)
	scene_link.destination_reference = destination_reference
	scene_link.exit_location = exit_location
	scene_link.exit_direction = exit_direction
