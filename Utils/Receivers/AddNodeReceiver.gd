extends Node2D
class_name AddNodeReceiver

export (String) var signal_code = "" 
export (PackedScene) var new_node_reference = null
var triggered : bool = false


func _ready():
	SignalBus.connect("add_node", self, "add_node_to")

func add_node_to(transmitted_code) -> Node:
	if transmitted_code == signal_code:
		triggered = true
		var new_node = new_node_reference.instance()
		new_node.global_position = global_position
		get_parent().add_child(new_node)
		return new_node
	return null 

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"triggered" : triggered,
	}
	return save_dict
