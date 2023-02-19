extends Node
class_name SpeechAction

signal finished

export (Array, String) var text_array

var active: bool = true

func interact() -> void:
	if active:
		UI.TextBox.queue_text(text_array)
		yield(UI.TextBox, "finished")
	emit_signal("finished")

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"active" : active,
	}
	return save_dict
