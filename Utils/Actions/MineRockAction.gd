extends Node
class_name MineRockAction

signal finished
signal has_follow_up_quest(quest, speaker)
signal strike

export var resilience : int = 5

var active: bool = true

func interact() -> void:
	if active:
		resilience -= 1
		emit_signal("strike")
	if resilience <= 0:
		active = false
		emit_signal("finished")

