extends QuestObjective
class_name QuestSlayObjective

export var amount: int
export var target_to_slay: PackedScene

func _on_enemy_died(enemy) -> void:
	var quest = get_parent().get_parent()
	var is_active = QuestSystem.active_quests.find(quest) != null
	if is_active:
		if completed or enemy.masterScene.resource_path != target_to_slay.resource_path:
			return
		amount -= 1
		emit_signal("updated", self)
		if amount == 0 and not completed:
			finish()

func as_text() -> String:
	return(
		"Banish %s %s(s) %s"
		% [str(amount), target_to_slay.instance().name, "(completed)" if completed else ""]
	)

