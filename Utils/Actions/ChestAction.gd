extends Node
class_name ChestAction

signal started
signal finished

export (Array, Resource) var items
export (int) var gold
export (bool) var locked

var active: bool = true

func interact() -> void:
	if (locked and Inventory.has_item(Inventory.ItemResources.KEY)) or !locked:
		locked = false
		consume_key()
		emit_signal("started")
		for item in items:
			Inventory.pick_up_item(item)
		Inventory.change_gold(gold)
		UI.TextBox.queue_text(create_alert_text_array())
		active = false
		emit_signal("finished")
	elif locked and !Inventory.has_item(Inventory.ItemResources.KEY):
		UI.TextBox.queue_text(["The chest appears to be locked."])
		emit_signal("finished")
	else:
		UI.TextBox.queue_text(["Something went wrong."])
		emit_signal("finished")
		
	
func create_alert_text_array():
	var alert_text = "You found a "
	for index in len(items):
		alert_text += items[index].name
		if index < len(items) - 2:
			alert_text += ", a "
		elif index == len(items)-2:
			if gold > 0:
				alert_text += ", a "
			else:
				alert_text += ", and a "
	if gold > 0:
		alert_text += ", and " + str(gold) + " gold"
	alert_text += " in the chest."
	return [alert_text]
	
func consume_key():
	for index in len(Inventory.inventory):
		if Inventory.inventory[index] != null and Inventory.inventory[index].type == "key":
			Inventory.consume_item(index)
			break
