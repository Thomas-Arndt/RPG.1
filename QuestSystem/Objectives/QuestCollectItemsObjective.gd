extends QuestObjective
class_name QuestCollectItemsObjective

export (Array, Resource) var items

var item_counts_by_item_name : Dictionary = {}
	
func _ready() -> void:
	Inventory.connect("item_changed", self, "_on_Inventory_item_changed")
	for item in items:
		item_counts_by_item_name[item.name] = item_counts_by_item_name.get(item.name, 0) + 1

func _on_Inventory_item_changed(indices):
	if not completed:
		for item in items:
			if item_counts_by_item_name.get(item.name, 0) > Inventory.item_quantity(item):
				return
		finish()
