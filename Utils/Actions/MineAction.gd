extends Node
class_name MineAction

signal finished
signal has_follow_up_quest(quest, speaker)

export (Resource) var mine_item

var mine_quantity : int = 1

var active: bool = true

func interact() -> void:
	if active and mine_item != null:
		Inventory.pick_up_item(mine_item)
		mine_quantity -= 1
	if mine_quantity <= 0:
		active = false
		emit_signal("finished")

