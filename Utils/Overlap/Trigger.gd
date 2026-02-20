extends Node2D
class_name Trigger

export var active : bool = false

var triggered = false

func trigger():
	print("trigger method needs to be overwritten.")

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"active" : active,
		"triggered": triggered
	}
	return save_dict
