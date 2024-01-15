extends Node
class_name CompleteMultipleQuestAction

signal finished
signal has_follow_up_quest(quest, speaker)

export (Array, PackedScene) var sub_quest_references
export var main_quest_reference: PackedScene
export var follow_up_quest: PackedScene
export var speaker_name: String 
export (Array, String) var deliver_text
export var active: bool = false

var main_quest: Quest = null
var quests : Array = []
var completed_quests : int = 0

func _ready():
	assert(main_quest_reference)
	var main_reference_instance = main_quest_reference.instance()
	main_quest = QuestSystem.find_available(main_reference_instance)
	if main_quest == null:
		main_quest = QuestSystem.active_quests.find(main_reference_instance)
	if main_quest == null:
		main_quest = QuestSystem.completed_quests.find(main_reference_instance)
	for quest_reference in sub_quest_references:
		connect_completed_signals(quest_reference)

func connect_completed_signals(quest_reference):
	var reference_instance = quest_reference.instance()
	var quest = QuestSystem.find_available(reference_instance)
	if quest == null:
		quest = QuestSystem.active_quests.find(reference_instance)
	if quest == null:
		quest = QuestSystem.completed_quests.find(reference_instance)
	if quest != null:
		if not quest.is_connected("delivered", self, "_on_Quest_delivered"):
			quest.connect("delivered", self, "_on_Quest_delivered")
		quests.append(quest)

func _on_Quest_delivered():
	completed_quests += 1
	if completed_quests >= len(quests):
		main_quest.emit_signal("completed")
		active = true

func interact() -> void:
	if not active or not all_quests_delivered():
		emit_signal("finished")
		return
	if UI.TextBox.complete:
		if not has_all_required_items():
			emit_signal("finished")
		else:
			QuestSystem.deliver(main_quest)
			active = false
			UI.TextBox.queue_text(main_quest.deliverText, speaker_name)
			yield(UI.TextBox, "finished")
			emit_signal("finished")
			get_tree().get_nodes_in_group("World")[0].save_scene()
			if (follow_up_quest != null):
				emit_signal("has_follow_up_quest", follow_up_quest, speaker_name)

func all_quests_delivered():
	var all_complete = true
	for quest_reference in sub_quest_references:
		var quest = QuestSystem.delivered_quests.find(quest_reference.instance())
		if quest == null:
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
		"completed_quests" : completed_quests,
	}
	return save_dict
