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
		quest.notify_slay_objectives()
		quest._start()

func _on_Quest_completed(quest):
	active_quests.remove_child(quest)
	completed_quests.add_child(quest)

func deliver(quest: Quest):
	var rewards = quest.get_rewards()
	completed_quests.remove_child(quest)
	delivered_quests.add_child(quest)
	quest._deliver()
	PlayerStats.change_experience(rewards.experience)
	Inventory.change_gold(rewards.gold)
	for item in rewards.items:
		var existing_index = null
		if item.item.can_stack:
			for i in len(Inventory.inventory):
				if Inventory.inventory[i] is Item and Inventory.inventory[i].name == item.item.name:
					existing_index = i
		var new_index = 0
		while (Inventory.inventory[new_index] != null && new_index < len(Inventory.inventory)):
			new_index += 1
		if existing_index != null:
			Inventory.pick_up_item(existing_index, item.item, item.quantity)
		elif (new_index < len(Inventory.inventory)):
			Inventory.pick_up_item(new_index, item.item, item.quantity)
