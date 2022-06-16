extends Node
class_name InProgressQuestAction

signal finished
signal has_follow_up_quest(quest)

export var quest_reference: PackedScene
export var speaker_name: String

var quest: Quest = null

var active: bool = false

func _ready():
	assert(quest_reference)
	quest = QuestSystem.find_available(quest_reference.instance())
	quest.connect("started", self, "_on_Quest_started")
	quest.connect("delivered", self, "_on_Quest_completed")

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
