extends Node
class_name CompletedQuestAction

signal finished

export var quest_reference: PackedScene
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
	if UI.TextBox.complete:
		QuestSystem.deliver(quest)
		UI.TextBox.queue_text(quest.deliverText)
		yield(UI.TextBox, "finished")
		active = false
		emit_signal("finished")	
