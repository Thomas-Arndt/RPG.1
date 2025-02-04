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

export var _reward_experience: int
export var _reward_gold: int

var active: bool = false

func _start():
	for objective in get_objectives():
		objective.connect("completed", self, "_on_Objective_completed")
	active = true
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
	active = false
	emit_signal("delivered")

func _apply_environmental_rewards():
	for reward in _environment_rewards.get_children():
		reward.apply()

func get_rewards() -> Dictionary:
	return {'experience': _reward_experience, 'gold': _reward_gold, 'items': _reward_items.get_children()}

func get_rewards_as_text() -> Array:
	var text := []
	text.append(" - Experience: " + str(_reward_experience) + "\n - Gold: " + str(_reward_gold) )
	return text 

func save() -> Dictionary:
	var slay_objectives_amounts: Dictionary
	for obj in objectives.get_children():
		if obj is QuestSlayObjective:
			slay_objectives_amounts[obj.get_target_name()] = obj.amount
	var save_dict = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"name" : get_name(),
		"active": active,
		"slay_objective_amounts": slay_objectives_amounts,
	}
	return save_dict
