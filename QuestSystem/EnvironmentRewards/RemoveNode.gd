extends Node

export (String) var signal_code = ""

func apply():
	SignalBus.emit_signal("remove_node", signal_code)
