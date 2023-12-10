extends QuestObjective
class_name QuestDeliverItemObjective

export var item : Resource
	
func _ready() -> void:
	var quest = get_parent().get_parent()
	quest.connect("started", self, "_on_Quest_started")
	quest.connect("completed", self, "_on_Quest_completed")	
	quest.connect("delivered", self, "_on_Quest_delivered")	

func _on_Quest_started():
	finish()

func _on_Quest_completed():
	Inventory.pick_up_item(item)

func _on_Quest_delivered():
	var item_index = Inventory.get_item_index(item)
	if item_index >= 0:
		Inventory.remove_item(item_index)
