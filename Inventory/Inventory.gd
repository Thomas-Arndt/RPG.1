extends Node

signal gold_changed(value)
signal max_gold_changed(value)

var gold: int = 0 setget set_gold
var max_gold: int = 99 setget set_max_gold

func _ready():
	pass # Replace with function body.

func set_gold(value):
	gold = value
	emit_signal("gold_changed", value)

func change_gold(value):
	gold += value
	gold = clamp(gold, 0, max_gold)
	emit_signal("gold_changed", value)
	
func set_max_gold(value):
	max_gold = value
	emit_signal("max_gold_changed", value)
