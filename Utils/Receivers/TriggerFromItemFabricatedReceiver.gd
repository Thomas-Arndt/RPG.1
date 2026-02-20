extends Node
class_name TriggerFromItemFabricatedReceiver

export var item_resource : Resource

var triggered : bool = false

func _ready():
	SignalBus.connect("TriggerFromItemFabricated", self, "_trigger_from_item_fabricated")

func _trigger_from_item_fabricated(item):
	if not triggered:
		if item is Item and item.name != item_resource.name:
			return
		triggered = true
		var parent = get_parent()
		if parent is Trigger:
			parent.trigger()
			
func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"triggered" : triggered,
	}
	return save_dict
