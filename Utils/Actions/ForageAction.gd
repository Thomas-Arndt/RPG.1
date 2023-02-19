extends Node
class_name ForageAction

signal finished

export (Array, Resource) var forage_items

var active: bool = true

func interact() -> void:
	if active and len(forage_items) > 0:
		for item in forage_items:
			Inventory.pick_up_item(item)
	emit_signal("finished")
