extends Node
class_name CompletedQuestAction

signal finished
signal has_follow_up_quest(quest, speaker)

export var quest_reference: PackedScene
export var follow_up_quest: PackedScene
export var speaker_name: String 
export var active: bool = false

var quest: Quest = null


func _ready():
	set_quest()
	
func set_quest():
	assert(quest_reference)
	var reference_instance = quest_reference.instance()
	quest = QuestSystem.find_available(reference_instance)
	if quest == null:
		quest = QuestSystem.active_quests.find(reference_instance)
	if quest == null:
		quest = QuestSystem.completed_quests.find(reference_instance)
	if quest != null:
		if not quest.is_connected("completed", self, "_on_Quest_completed"):
			quest.connect("completed", self, "_on_Quest_completed")

func _on_Quest_completed():
	active = true

func interact() -> void:
	quest = QuestSystem.completed_quests.find(quest_reference.instance())
	if not active or quest == null:
		emit_signal("finished")
		return
	if quest != null and UI.TextBox.complete:
		if not hasAllRequiredItems(quest):
			UI.TextBox.queue_text(quest.progressText, speaker_name)
			yield(UI.TextBox, "finished")
			emit_signal("finished")
		else:
			QuestSystem.deliver(quest)
			active = false
			UI.TextBox.queue_text(quest.deliverText, speaker_name)
			yield(UI.TextBox, "finished")
			if (follow_up_quest != null):
				emit_signal("finished")
				emit_signal("has_follow_up_quest", follow_up_quest, speaker_name)
			else:
				emit_signal("finished")

func hasAllRequiredItems(quest):
	var objectives = quest.get_objectives()
	for objective in objectives:
		if objective is QuestOwnItemObjective or objective is QuestCollectItemsObjective:
			var required_items : Dictionary
			for requiredItem in objective.items:
				if required_items.has(requiredItem.name):
					required_items[requiredItem.name] += 1
				else:
					required_items[requiredItem.name] = 1
			for requiredItem in objective.items:
				if not Inventory.has_item(requiredItem):
					return false
				if Inventory.item_quantity(requiredItem) < required_items[requiredItem.name]:
					return false
	return true

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"class" : "CompletedQuestAction",
		"active" : active,
	}
	return save_dict
