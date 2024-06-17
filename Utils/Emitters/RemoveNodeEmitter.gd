extends Node

export var signal_name : String 
export var signal_code : String

func _ready():
	get_parent().connect(signal_name, self, "emit_remove_node_signal")

func emit_remove_node_signal():
	SignalBus.emit_signal("remove_node", signal_code)
