extends StaticBody2D
class_name Chest

export (bool) var locked = false
export (Resource) var loot = null
export (int) var quantity = 1

onready var interaction_zone = $InteractionZone

func _ready():
	pass
