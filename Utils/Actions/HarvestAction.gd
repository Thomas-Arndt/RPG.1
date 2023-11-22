extends Node
class_name HarvestAction

signal finished
signal has_follow_up_quest(quest, speaker)

var harvest_item

var active: bool = false

func set_harvest_item(crop):
	harvest_item = crop
		
func set_active(state):
	active = state

func interact() -> void:
	if active and harvest_item != null:
		Inventory.pick_up_item(harvest_item, harvest_item.quantity)
		active = false
	emit_signal("finished")
