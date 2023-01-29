extends Node

var Action: Node
var giveQuestAction: PackedScene = preload("res://Utils/Actions/GiveQuestAction.tscn")

func _ready():
	for action in get_children():
		action.connect("has_follow_up_quest", self, "_on_has_follow_up_quest")

func _on_has_follow_up_quest(quest, speaker_name):
	Action = giveQuestAction.instance()
	Action.quest_reference = quest
	Action.speaker_name = speaker_name
	add_child(Action)
	get_parent().start_interaction()
