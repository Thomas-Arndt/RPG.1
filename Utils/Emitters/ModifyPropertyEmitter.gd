extends Node

export var signal_name : String 
export var signal_code : String

func _ready():
	get_parent().connect(signal_name, self, "emit_modify_property_signal")

func emit_modify_property_signal():
	SignalBus.emit_signal("modify_node_property", signal_code)
