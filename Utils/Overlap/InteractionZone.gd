extends Area2D

export var text = []
export var quest_reference: PackedScene = null

func hasText():
	return len(text) > 0

#export var quest_reference: PackedScene
#var quest: Quest = null
#var active: bool = true

#func _ready() -> void:
#	assert(quest_reference)
#	quest = QuestSystem.find_available(quest_reference.instance())
#	quest.connect("started", self, "On_Quest_started")

#func _on_Quest_started():
#	active = false

#func interact() -> void:
#	if not active:
#		return
#	var quest: Quest = quest_reference.instance()
#	if not QuestSystem.is_available(quest):
#		return
#	QuestSystem.start(quest)
