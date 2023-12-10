extends Node
class_name MineAction

signal finished
signal has_follow_up_quest(quest, speaker)

export var resilience : int = 5

var active: bool = true

func interact() -> void:
	if active:
		resilience -= 1
	if resilience <= 0:
		active = false
		emit_signal("finished")

