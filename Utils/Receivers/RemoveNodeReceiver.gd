extends Node
class_name RemoveNodeReceiver

export (String) var signal_code = "" 

var triggered : bool = false

func _ready():
	SignalBus.connect("remove_node", self, "remove_node")

func remove_node(transmitted_code):
	if (transmitted_code == signal_code):
		triggered = true
		var child = get_child(0)
		if child != null:
			child.queue_free()

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"triggered" : triggered,
	}
	return save_dict
