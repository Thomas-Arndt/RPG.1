extends QuestObjective
class_name QuestCollectItemsObjective

export (Array, Resource) var items
	
func _ready() -> void:
	var quest = get_parent().get_parent()
	quest.connect("started", self, "_on_Quest_started")
	quest.connect("completed", self, "_on_Quest_completed")	
	quest.connect("delivered", self, "_on_Quest_delivered")	

func _on_Quest_started():
	finish()

func _on_Quest_delivered():
	for item in items:
		var item_index = Inventory.get_item_index(item)
		if item_index >= 0:
			Inventory.consume_item(item_index)
