extends Node

export (String) var signal_code = "" 

func _ready():
	SignalBus.connect("remove_node", self, "remove_parent")

func remove_parent(transmitted_code):
	if (transmitted_code == signal_code):
		get_parent().queue_free()

