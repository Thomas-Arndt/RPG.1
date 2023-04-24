extends Node
class_name ChestAction

signal started
signal finished

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
