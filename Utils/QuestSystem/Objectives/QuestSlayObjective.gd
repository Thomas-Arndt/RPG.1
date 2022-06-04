extends QuestObjective
class_name QuestSlayObjective

export var amount: int
export var target_to_slay: PackedScene

func connect_signals() -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.connect("died", self, "_on_enemy_died")

func _on_enemy_died(enemy) -> void:
	print(enemy.masterScene.resource_path)
	print(target_to_slay.resource_path)
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

