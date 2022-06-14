extends Node
class_name CompletedQuestAction

signal finished
signal has_follow_up_quest(quest)

export var quest_reference: PackedScene
export var follow_up_quest: PackedScene
export var speaker_name: String 

var quest: Quest = null

var active: bool = false

func _ready():
	assert(quest_reference)
	quest = QuestSystem.find_available(quest_reference.instance())
	quest.connect("completed", self, "_on_Quest_completed")

func _on_Quest_completed():
	active = true

func interact() -> void:
	if not active:
		emit_signal("finished")
		return
	if QuestSystem.completed_quests.find(quest) != null and UI.TextBox.complete:
		QuestSystem.deliver(quest)
		UI.TextBox.queue_text(quest.deliverText, speaker_name)
		yield(UI.TextBox, "finished")
		active = false
		if (follow_up_quest != null):
			emit_signal("has_follow_up_quest", follow_up_quest, speaker_name)
		emit_signal("finished")
