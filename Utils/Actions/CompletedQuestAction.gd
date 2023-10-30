extends Node
class_name CompletedQuestAction

signal finished
signal has_follow_up_quest(quest, speaker)

export var quest_reference: PackedScene
export var follow_up_quest: PackedScene
export var speaker_name: String 
export var active: bool = false

var quest: Quest = null


func _ready():
	set_quest()
	
func set_quest():
	assert(quest_reference)
	var reference_instance = quest_reference.instance()
	quest = QuestSystem.find_available(reference_instance)
	if quest == null:
		quest = QuestSystem.active_quests.find(reference_instance)
	if quest == null:
		quest = QuestSystem.completed_quests.find(reference_instance)
	if quest != null:
		quest.connect("completed", self, "_on_Quest_completed")

func _on_Quest_completed():
	active = true

func interact() -> void:
	if not active:
		emit_signal("finished")
		return
	quest = QuestSystem.completed_quests.find(quest_reference.instance())
	if quest != null and UI.TextBox.complete:
		QuestSystem.deliver(quest)
		active = false
		UI.TextBox.queue_text(quest.deliverText, speaker_name)
		yield(UI.TextBox, "finished")
		if (follow_up_quest != null):
			emit_signal("finished")
			emit_signal("has_follow_up_quest", follow_up_quest, speaker_name)
		else:
			emit_signal("finished")

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"class" : "CompletedQuestAction",
		"active" : active,
	}
	return save_dict
