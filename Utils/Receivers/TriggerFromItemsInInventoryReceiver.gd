extends Node
class_name TriggerFromItemsInInventoryReceiver

export (Array, Resource) var items_required

var triggered : bool = false
var item_dictionary : Dictionary

func _ready():
	SignalBus.connect("TriggerFromItemReceived", self, "_trigger_from_item_Received")
	for item in items_required:
		item_dictionary[item.name] = item_dictionary.get(item.name, 0) + 1

func _trigger_from_item_Received(item):
	if not triggered:
		if item is Item and has_required_resources():
			triggered = true
			var parent = get_parent()
			if parent is Trigger:
				parent.trigger()

func has_required_resources():
	for key in item_dictionary.keys():
		var inventory_item = Inventory.get_item_by_name(key)
		if inventory_item != null:
			if inventory_item.quantity < item_dictionary[key]:
				return false
	return true

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"triggered" : triggered,
	}
	return save_dict
