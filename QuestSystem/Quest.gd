extends Node
class_name Quest

signal started
signal completed
signal delivered

onready var objectives = $Objectives
onready var _reward_items: Node = $ItemRewards
onready var _environment_rewards: Node = $EnvironmentRewards

export var title: String
export var description: String
export var startText: Array
export var progressText: Array
export var deliverText: Array

export var reward_on_delivery: bool = false
export var _reward_experience: int
export var _reward_gold: int

func _start():
	for objective in get_objectives():
		objective.connect("completed", self, "_on_Objective_completed")
	emit_signal("started")
	
func get_objectives():
	return objectives.get_children()

func get_completed_objectives():
	var completed: Array = []
	for objective in get_objectives():
		if not objective.completed:
			continue
		completed.append(objective)
	return completed

func _on_Objective_completed(objective) -> void:
	if get_completed_objectives().size() == get_objectives().size():
		emit_signal("completed")

func _deliver():
	if len(_environment_rewards.get_children()) > 0:
		_apply_environmental_rewards()
	emit_signal("delivered")

func _apply_environmental_rewards():
	for reward in _environment_rewards.get_children():
		reward.apply()
	
func notify_slay_objectives() -> void:
	for objective in get_objectives():
		if not objective is QuestSlayObjective:
			continue
		(objective as QuestSlayObjective).connect_signals()

func get_rewards() -> Dictionary:
	return {'experience': _reward_experience, 'gold': _reward_gold, 'items': _reward_items.get_children()}

func get_rewards_as_text() -> Array:
	var text := []
	#	text.append(" - [%s] x (%s)\n" % [item.item.name, str(item.amount)])
	text.append(" - Experience: " + str(_reward_experience) + "\n - Gold: " + str(_reward_gold) )
	#for item in _reward_items.get_children():
	return text 
