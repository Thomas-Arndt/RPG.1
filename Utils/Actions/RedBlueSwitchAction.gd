extends Node
class_name RedBlueSwitchAction

signal finished
signal has_follow_up_quest(quest, speaker)

var active: bool = true

func interact() -> void:
	emit_signal("finished")
