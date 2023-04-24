extends Node
class_name InformationAction

signal started
signal finished
signal opened

export (Array, Resource) var items
export (int) var gold
export (bool) var locked

var active: bool = true

func interact() -> void:
	if active:
		if (locked and Inventory.has_item(Inventory.ItemResources.KEY)) or !locked:
			if locked:
				locked = false
				consume_key()
			emit_signal("started")
			for item in items:
				Inventory.pick_up_item(item)
			Inventory.change_gold(gold)
			active = false
			UI.TextBox.queue_text(create_alert_text_array())
			yield(UI.TextBox, "finished")
			active = false
			emit_signal("finished")
		elif locked and !Inventory.has_item(Inventory.ItemResources.KEY):
			UI.TextBox.queue_text(["The chest appears to be locked."])
			yield(UI.TextBox, "finished")
			emit_signal("finished")
		else:
			UI.TextBox.queue_text(["Something went wrong."])
			yield(UI.TextBox, "finished")
			emit_signal("finished")
	else:
		emit_signal("finished")		
		
	
func create_alert_text_array():
	var item_table : Dictionary = get_items_hash_table()
	var alert_text = "You found "
	var index = 0
	for key in item_table.keys():
		alert_text += str(item_table[key]) + " " + key
		if index < len(item_table.keys()) - 2:
			alert_text += ", "
		elif index == len(item_table.keys())-2:
			if gold > 0:
				alert_text += ", "
			else:
				alert_text += ", and "
	if gold > 0:
		if len(item_table.keys()) > 0:
			alert_text += "and " + str(gold) + " gold"
		else:
			alert_text += str(gold) + " gold"
	alert_text += " in the chest."
	return [alert_text]

func get_items_hash_table() -> Dictionary:
	var item_table : Dictionary = {}
	for item in items:
		if item_table.has(item.name):
			item_table[item.name] += 1
		else:
			item_table[item.name] = 1
	return item_table

func consume_key():
	for index in len(Inventory.inventory):
		if Inventory.inventory[index] != null and Inventory.inventory[index].type == "key":
			Inventory.consume_item(index)
			break

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"gold" : gold,
		"locked" : locked,
		"active" : active,
	}
	return save_dict
