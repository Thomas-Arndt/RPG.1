extends Node

export var signal_code : String = ""

func apply():
	UI.TextBox.connect("finished", self, "run_function")
	
func run_function():
	SignalBus.emit_signal("run_node_function", signal_code)
