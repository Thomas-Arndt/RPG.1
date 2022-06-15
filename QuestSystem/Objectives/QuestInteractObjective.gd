extends QuestObjective
class_name QuestInteractObjective

func _ready() -> void:
	get_parent().get_parent().connect("started", self, "_on_Quest_started")

func _on_Quest_started():
	finish()

	
