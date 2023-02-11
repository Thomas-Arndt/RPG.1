extends Node
class_name GiveQuestAction

signal finished
signal has_follow_up_quest(quest)

export var quest_reference: PackedScene
export var speaker_name: String

var quest: Quest = null

var active: bool = true

func _ready():
	assert(quest_reference)
	quest = QuestSystem.find_available(quest_reference.instance())
	if quest != null:
		quest.connect("started", self, "_on_Quest_started")

func _on_Quest_started():
	active = false

func interact() -> void:
	if not active:
		emit_signal("finished")
		return
	var quest: Quest = quest_reference.instance()
	if QuestSystem.find_available(quest) and UI.TextBox.complete:
		QuestSystem.start(quest)
		UI.TextBox.queue_text(quest.startText, speaker_name)
		yield(UI.TextBox, "finished")
		emit_signal("finished")	

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"active" : active,
	}
	return save_dict
