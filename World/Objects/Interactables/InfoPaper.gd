extends StaticBody2D

export (Array, String) var information_array = []
export (bool) var collisions_on = true
export (bool) var interactable = true

onready var action = $InteractionZone/Actions/InformationAction
onready var collision_shape = $CollisionShape2D
onready var interaction_shape = $InteractionZone/CollisionShape2D

func _ready():
	action.information_array = information_array
	if !collisions_on:
		collision_shape.set_deferred("disabled", true)
	if !interactable:
		interaction_shape.set_deferred("disabled", true)
