extends Node

export var signal_code : String = ""

func apply():
	SignalBus.emit_signal("modify_node_property", signal_code)
