extends Node
class_name RunFunctionReceiver

export var signal_code : String = "" 
export var function : String = ""

var triggered : bool = false

func _ready():
	SignalBus.connect("run_node_function", self, "run_function")

func run_function(transmitted_code):
	if transmitted_code == signal_code and not triggered:
		triggered = true
		var parent = get_parent()
		parent.call_deferred(function, get_tree().get_nodes_in_group("Player")[0])
