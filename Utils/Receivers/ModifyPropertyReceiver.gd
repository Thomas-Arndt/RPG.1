extends Node
class_name ModifyPropertyReceiver

export var signal_code : String = "" 
export var property : String = ""
export var value_array : Array

var triggered : bool = false

func _ready():
	SignalBus.connect("modify_node_property", self, "modify_property")

func modify_property(transmitted_code):
	if (transmitted_code == signal_code):
		triggered = true
		var parent = get_parent()
		parent[property] = value_array[0]
