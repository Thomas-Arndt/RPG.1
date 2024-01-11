extends Node
class_name CompleteMultipleQuestAction

signal finished
signal has_follow_up_quest(quest, speaker)

export (Array, PackedScene) var quest_references
export var follow_up_quest: PackedScene
export var speaker_name: String 
export (Array, String) var deliver_text
export var active: bool = false

var quests : Array = []

func _ready():
	for quest_reference in quest_references:
		var reference_instance = quest_reference.instance()
		var quest = QuestSystem.find_available(reference_instance)
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
	if not active or not all_quests_delivered():
		emit_signal("finished")
		return
	if UI.TextBox.complete:
		if not has_all_required_items():
			emit_signal("finished")
		else:
			deliver_quests()
			active = false
			UI.TextBox.queue_text(deliver_text, speaker_name)
			yield(UI.TextBox, "finished")
			emit_signal("finished")
			get_tree().get_nodes_in_group("World")[0].save_scene()
			if (follow_up_quest != null):
				emit_signal("has_follow_up_quest", follow_up_quest, speaker_name)

func deliver_quests():
	for quest in quests:
		QuestSystem.deliver(quest)
				
func all_quests_delivered():
	var all_complete = true
	for quest_reference in quest_references:
		var quest = QuestSystem.delivered_quests.find(quest_reference.instance())
		if quest != null:
			quests.append(quest)
		else:
			all_complete = false
	return all_complete

func has_all_required_items():
	var has_all_items = true
	for quest in quests:
		var objectives = quest.get_objectives()
		for objective in objectives:
			if objective is QuestOwnItemObjective:
				for requiredItem in objective.items:
					if not Inventory.has_item(requiredItem):
						has_all_items = false
	return has_all_items

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"class" : "CompleteMultipleQuestAction",
		"active" : active,
	}
	return save_dict
