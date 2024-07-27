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
		apply_modification()
		
func apply_modification():
		triggered = true
		var parent = get_parent()
		parent.set_deferred(property, value_array[0])

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"triggered" : triggered,
	}
	return save_dict
