extends Node
class_name InformationAction

signal started
signal finished
signal has_follow_up_quest(quest, speaker)

export (Array, String) var information_array

var active: bool = true

func interact() -> void:
	if active:
		active = false
		emit_signal("started")
		UI.TextBox.queue_text(information_array)
		yield(UI.TextBox, "finished")
		active = true
		emit_signal("finished")
