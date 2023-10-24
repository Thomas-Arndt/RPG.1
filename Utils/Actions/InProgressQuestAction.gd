extends Node
class_name InProgressQuestAction

signal finished
signal has_follow_up_quest(quest, speaker)

export var quest_reference: PackedScene
export var speaker_name: String

var quest: Quest = null

var active: bool = false

func _ready():
	assert(quest_reference)
	quest = QuestSystem.find_available(quest_reference.instance())
	if quest == null:
		quest = QuestSystem.active_quests.find(quest_reference.instance())
	if quest == null:
		quest = QuestSystem.completed_quests.find(quest_reference.instance())
	if quest != null:
		quest.connect("started", self, "_on_Quest_started")
		quest.connect("completed", self, "_on_Quest_completed")

func _on_Quest_started():
	active = true
	
func _on_Quest_completed():
	active = false

func interact() -> void:
	if not active:
		emit_signal("finished")
		return
	var quest: Quest = quest_reference.instance()
	if UI.TextBox.complete:
		UI.TextBox.queue_text(quest.progressText, speaker_name)
		yield(UI.TextBox, "finished")
		emit_signal("finished")	

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"active" : active,
	}
	return save_dict
