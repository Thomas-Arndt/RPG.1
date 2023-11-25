extends Node
class_name ForageAction

signal finished
signal has_follow_up_quest(quest, speaker)

export (Resource) var forage_item

var active: bool = true

func interact() -> void:
	if active and forage_item != null:
		Inventory.pick_up_item(forage_item)
	emit_signal("finished")
