extends Node
class_name GiveMultipleQuestAction


signal finished
signal has_follow_up_quest(quest, speaker)

export (Array, PackedScene) var quest_references
export var speaker_name: String
export var active: bool = true

var quests : Array = []

func _ready():
	for reference in quest_references:
		var quest = QuestSystem.find_available(reference.instance())
		if quest != null:
			quest.connect("started", self, "_on_Quest_started")

func _on_Quest_started():
	active = false

func interact() -> void:
	if not active:
		emit_signal("finished")
		return	
	if not verify_quests():
		quests = []
		emit_signal("finished")
		return
	else:
		start_quests()
		UI.TextBox.queue_text(quests[0].startText, speaker_name)
		yield(UI.TextBox, "finished")
		emit_signal("finished")	
		
func verify_quests() -> bool:
	var valid = true
	for reference in quest_references:
		var quest: Quest = reference.instance()
		if not QuestSystem.find_available(quest):
			valid = false
		else:
			quests.append(quest)
	return valid

func start_quests():
	for quest in quests:
		QuestSystem.start(quest)

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"class" : "GiveMultipleQuestAction",
		"active" : active,
	}
	return save_dict
