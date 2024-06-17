extends Node
class_name FloorSwitchReceiver

export (String) var signal_code
export (bool) var one_way_on = false
export (bool) var one_way_off = false
export (bool) var modify_property = false
export (Array, String) var property_array
export (Array) var value_array

enum STATES {
	ON,
	OFF
}

var triggered:bool = false
var last_trigger_state = null

func _ready():
	SignalBus.connect("floor_switch", self,  "_on_Floor_Switch_Signal")

func _on_Floor_Switch_Signal(code, state):
	if (code == signal_code):
		if (state == STATES.ON):
			if (modify_property):
				var parent = get_parent()
				for index in len(property_array):
					parent.set_deferred(property_array[index], value_array[index])
		elif (state == STATES.OFF):
			pass
		triggered = true
		last_trigger_state = state


func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"triggered" : triggered,
		"last_triggered_state" : last_trigger_state,
	}
	return save_dict
