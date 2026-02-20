extends QuestObjective
class_name QuestFabricateItemObjective

export var amount: int
export var item_to_fabricate: Resource
var node = self

func _ready():
	SignalBus.connect("item_fabricated", self, "_on_item_fabricated")

func _on_item_fabricated(item) -> void:
	var quest = get_parent().get_parent()
	var is_active = QuestSystem.active_quests.find(quest) != null
	if is_active:
		if completed or item.filename != item_to_fabricate.resource_path:
			return
		amount -= 1
		emit_signal("updated", self)
		QuestSystem.save_quest_progress()
		if amount == 0 and not completed:
			finish()

func get_target_name() -> String:
	return item_to_fabricate.instance().Name.to_lower()

func as_text() -> String:
	return(
		"Fabricate %s %s%s %s" % 
		[str(amount), 
		item_to_fabricate.instance().Name.to_lower(), 
		"s" if amount > 1 else "", 
		"(completed)" if completed else ""]
	)

