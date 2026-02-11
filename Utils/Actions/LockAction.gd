extends Node
class_name LockAction

signal started
signal finished
signal unlocked
signal has_follow_up_quest(quest, speaker)

export (Resource) var key_resource = preload("res://Inventory/Items/Keys/Key.tres")
export (bool) var accessible = false
export (bool) var locked = true


var active: bool = true

func interact() -> void:
	emit_signal("started")
	if active:
		if accessible:
			if (locked and Inventory.has_item(key_resource)):
				if locked:
					locked = false
					consume_key()
					emit_signal("unlocked")
				active = false
				UI.TextBox.queue_text(["* * Click! * *"])
				emit_signal("finished")
			elif locked and !Inventory.has_item(Inventory.ItemResources.KEY):
				UI.TextBox.queue_text(["The door appears to be locked."])
				yield(UI.TextBox, "finished")
				emit_signal("finished")
			elif not locked:
				emit_signal("unlocked")
				emit_signal("finished")
			else:
				UI.TextBox.queue_text(["Something went wrong."])
				yield(UI.TextBox, "finished")
				emit_signal("finished")
		else:
			emit_signal("finished")
	else:
		emit_signal("finished")		

func consume_key():
	for index in len(Inventory.inventory):
		if Inventory.inventory[index] != null and Inventory.inventory[index].type == key_resource.type:
			Inventory.consume_item(index)
			break

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"locked" : locked,
		"active" : active,
		"class" : "LockAction"
	}
	return save_dict
