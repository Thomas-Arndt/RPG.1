extends Node

onready var available_quests = $Available
onready var active_quests = $Active
onready var completed_quests = $Completed
onready var delivered_quests = $Delivered

func find_available(reference: Quest) -> Quest:
	return available_quests.find(reference)

func get_available_quests() -> Array:
	return available_quests.get_quests()

func is_available(reference: Quest) -> bool:
	return available_quests.find(reference) != null
	
func start(reference: Quest):
	var quest: Quest = available_quests.find(reference)
	if quest != null:
		quest.connect("completed", self, "_on_Quest_completed", [quest])
		available_quests.remove_child(quest)
		active_quests.add_child(quest)
		quest._start()
		save_quest_progress()

func _on_Quest_completed(quest):
	active_quests.remove_child(quest)
	completed_quests.add_child(quest)
	save_quest_progress()

func deliver(quest: Quest):
	var rewards = quest.get_rewards()
	completed_quests.remove_child(quest)
	delivered_quests.add_child(quest)
	quest._deliver()
	PlayerStats.change_experience(rewards.experience)
	Inventory.change_gold(rewards.gold)
	for item in rewards.items:
		Inventory.pick_up_item(item.item, item.quantity)
	save_quest_progress()

func get_quest_log():
	var quest_log_dict : Dictionary = {
		"active_quests": [],
		"completed_quests": [],
	}
	for quest in active_quests.get_quests():
		var objectives : Array = []
		for objective in quest.objectives.get_children():
			objectives.append(objective.as_text())
		quest_log_dict.active_quests.append({
			"title": quest.title,
			"description": quest.description,
			"objectives": objectives,
			"rewards": quest.get_rewards(),
			"state": "active",
		})
	for quest in completed_quests.get_quests():
		var objectives : Array = []
		for objective in quest.objectives.get_children():
			objectives.append(objective.as_text())
		quest_log_dict.completed_quests.append({
			"title": quest.title,
			"description": quest.description,
			"objectives": objectives,
			"rewards": quest.get_rewards(),
			"state": "completed",
		})
	return quest_log_dict

func save_quest_progress():
	var save_game = File.new()
	save_game.open("user://Saves/%s/%s.save" % [WorldStats.save_block, get_name()], File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("QuestPersist")
	for node in save_nodes:
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		var node_data = node.call("save")
		save_game.store_line(to_json(node_data))
	save_game.close()
	get_tree().get_nodes_in_group("World")[0].save_scene()

func load_quest_progress():
	var save_game = File.new()
	if not save_game.file_exists("user://Saves/%s/%s.save" % [WorldStats.save_block, get_name()]):
		return
	var save_nodes = get_tree().get_nodes_in_group("QuestPersist")
	save_game.open("user://Saves/%s/%s.save" % [WorldStats.save_block, get_name()], File.READ)
	while save_game.get_position() < save_game.get_len():
		var node_data = parse_json(save_game.get_line())
		for quest in available_quests.get_children():
			if quest.get_name() == node_data["name"]:
				available_quests.remove_child(quest)
				get_node(node_data["parent"]).add_child(quest)
				for objective in quest.get_objectives():
					objective.connect("completed", quest, "_on_Objective_completed")
				quest.connect("completed", self, "_on_Quest_completed", [quest])
				break
	save_game.close()
