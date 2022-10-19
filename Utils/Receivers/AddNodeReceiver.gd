extends Node2D

export (String) var signal_code = "" 
export (PackedScene) var new_node_reference = null


func _ready():
	SignalBus.connect("add_node", self, "add_node_to")

func add_node_to(transmitted_code):
	if transmitted_code == signal_code:
		var new_node = new_node_reference.instance()
		new_node.global_position = global_position
		get_parent().add_child(new_node)
		queue_free()
