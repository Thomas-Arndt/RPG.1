extends QuestObjective
class_name QuestOwnItemObjective

export (Array, Resource) var items
	
func _ready() -> void:
	var quest = get_parent().get_parent()
	quest.connect("started", self, "_on_Quest_started")
	quest.connect("completed", self, "_on_Quest_completed")	
	quest.connect("delivered", self, "_on_Quest_delivered")	

func _on_Quest_started():
	finish()
