extends Node

var Action: Node

func _ready():
	for action in get_children():
		if not action.is_connected("has_follow_up_quest", self, "_on_has_follow_up_quest"):
			action.connect("has_follow_up_quest", self, "_on_has_follow_up_quest")

func _on_has_follow_up_quest(quest_reference, speaker_name):
	for child in get_children():
		if child is GiveQuestAction and child.quest_reference == quest_reference:
			child.active = true
	get_tree().get_nodes_in_group("World")[0].save_scene()
	QuestSystem.save_quest_progress()
