extends Node

export (String) var cutscene_name = ""

func apply():
	SignalBus.emit_signal("run_global_cutscene", cutscene_name)
