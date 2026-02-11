extends Node
class_name RemoveNodeReceiver

export (String) var signal_code = "" 

var triggered : bool = false
var use_save_node : bool = false

var save_node = preload("res://Utils/Receivers/SaveNode.tscn")

func _ready():
	SignalBus.connect("remove_node", self, "remove_node")

func remove_node(transmitted_code):
	if (transmitted_code == signal_code):
		triggered = true
		get_tree().get_nodes_in_group("World")[0].save_scene()
		var node_to_remove = get_child(0)
		if node_to_remove == null:
			node_to_remove = get_parent()
			use_save_node = true
		if node_to_remove != null:
			if use_save_node:
				var new_save_node = save_node.instance()
				new_save_node.set_save_dict(save())
				get_tree().get_nodes_in_group("World")[0].add_child(new_save_node)
			node_to_remove.queue_free()

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"triggered" : triggered,
	}
	return save_dict
