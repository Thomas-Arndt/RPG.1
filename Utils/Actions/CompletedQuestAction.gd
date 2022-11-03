extends Node
class_name CompletedQuestAction

signal finished
signal has_follow_up_quest(quest)

export var quest_reference: PackedScene
export var follow_up_quest: PackedScene
export var speaker_name: String 
export var active: bool = false

var quest: Quest = null


func _ready():
	assert(quest_reference)
	var reference_instance = quest_reference.instance()
	if !reference_instance.is_chest:
		quest = QuestSystem.find_available(reference_instance)
		quest.connect("completed", self, "_on_Quest_completed")
	else:
		quest = QuestSystem.completed_quests.find(reference_instance)

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
