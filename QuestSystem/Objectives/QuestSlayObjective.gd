extends QuestObjective
class_name QuestSlayObjective

export var amount: int
export var target_to_slay: PackedScene
var node = self

func _on_enemy_died(enemy) -> void:
	var quest = get_parent().get_parent()
	var is_active = QuestSystem.active_quests.find(quest) != null
	if is_active:
		if completed or enemy.filename != target_to_slay.resource_path:
			return
		amount -= 1
		emit_signal("updated", self)
		QuestSystem.save_quest_progress()
		if amount == 0 and not completed:
			finish()

func get_target_name() -> String:
	return target_to_slay.instance().Name.to_lower()

func as_text() -> String:
	return(
		"Banish %s %s%s %s" % 
		[str(amount), 
		target_to_slay.instance().Name.to_lower(), 
		"s" if amount > 1 else "", 
		"(completed)" if completed else ""]
	)

