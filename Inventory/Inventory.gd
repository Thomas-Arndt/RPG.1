extends Node

signal gold_changed(value)
signal max_gold_changed(value)
signal muon_pearls_changed(value)
signal max_muon_pearls_changed(value)
signal item_changed(indices)

var drag_data = null

var gold: int = 0 setget set_gold
var max_gold: int = 999 setget set_max_gold

var muon_pearls: int = 10 setget set_muon_pearls
var max_muon_pearls: int = 999 setget set_max_muon_pearls

export (Array, Resource) var inventory = [
	null, null, null, null, 
	null, null, null, null, 
	null, null, null, null, 
	null, null, null, null, 
	null, null, null, null
]

func _ready():
	pass

func set_gold(value):
	gold = value
	save_inventory()
	emit_signal("gold_changed", value)

func change_gold(value):
	gold += value
	gold = clamp(gold, 0, max_gold)
	save_inventory()
	emit_signal("gold_changed", value)
	
func set_max_gold(value):
	max_gold = value
	save_inventory()
	emit_signal("max_gold_changed", value)
	
func set_muon_pearls(value):
	muon_pearls = value
	emit_signal("muon_pearls_changed", value)

func change_muon_pearls(value):
	muon_pearls += value
	muon_pearls = clamp(muon_pearls, 0, max_muon_pearls)
	save_inventory()
	emit_signal("muon_pearls_changed", muon_pearls)

func set_max_muon_pearls(value):
	max_muon_pearls = value
	emit_signal("max_muon_pearls_changed", value)

func pick_up_item(item, quantity = 1, index = null):
	var item_index = 0
	if index != null:
		item_index = index
	else:
		item_index = pick_up_index(item)
	if inventory[item_index] == null:
		var previousItem = inventory[item_index]
		inventory[item_index] = item
		inventory[item_index].quantity = quantity
		save_inventory()
		emit_signal("item_changed", [item_index])
		SignalBus.emit_signal("TriggerFromItemReceived", item)
		return previousItem
	else:
		inventory[item_index].quantity += quantity
		save_inventory()
		emit_signal("item_changed", [item_index])
		SignalBus.emit_signal("TriggerFromItemReceived", item)
		return inventory[item_index]

func set_item(item_index, item):
	var previousItem = inventory[item_index]
	inventory[item_index] = item
	emit_signal("item_changed", [item_index])
	save_inventory()
	return previousItem
	
func swap_items(item_index, target_item_index):
	var targetItem = inventory[target_item_index]
	var item = inventory[item_index]
	inventory[target_item_index] = item
	inventory[item_index] = targetItem
	emit_signal("item_changed", [item_index, target_item_index])
	save_inventory()
	
func remove_item(item_index):
	var previousItem = inventory[item_index]
	inventory[item_index] = null
	emit_signal("item_changed", [item_index])
	save_inventory()
	return previousItem

func drop_item_container(pos: Vector2, parent_node: Node):
	var item_container = ItemScenes.CONTAINER.instance()
	item_container.global_position = Vector2(pos.x, pos.y+8)
	parent_node.add_child(item_container)
	
func pick_up_index(item_resource):
	var existing_index = null
	if item_resource.can_stack:
		for i in len(Inventory.inventory):
			if inventory[i] is Item and inventory[i].name == item_resource.name:
				existing_index = i
	var new_index = 0
	while (inventory[new_index] != null && new_index < len(inventory)):
		new_index += 1
	if existing_index != null:
		return existing_index
	elif (new_index < len(Inventory.inventory)):
		return new_index
	return null

func has_item(item) -> bool:
	for inventory_item in inventory:
		if inventory_item != null and inventory_item.type == item.type && inventory_item.name == item.name:
			return true
	return false
	
func item_quantity(item) -> int:
	for inventory_item in inventory:
		if inventory_item != null and inventory_item.type == item.type && inventory_item.name == item.name:
			return inventory_item.quantity
	return 0

func consume_item(index, quantity = 1):
	inventory[index].quantity -= quantity
	if inventory[index].quantity <= 0:
		inventory[index] = null
	UI.Backpack.inventory_display.update_inventory_display()

func get_item_index(item) -> int:
	for index in len(inventory):
		if inventory[index] != null and inventory[index].type == item.type && inventory[index].name == item.name:
			return index
	return -1
	
func save_inventory():
	var inventory_resources_array : Array = []
	for slot in inventory:
		if slot != null:
			inventory_resources_array.append({"path": slot.get_path(), "quantity": slot.quantity})
		else:
			inventory_resources_array.append({"path": null, "quantity": null})
	var save_game = File.new()
	save_game.open("user://Saves/%s/%s.save" % [WorldStats.save_block, get_name()], File.WRITE)
	var node_data = {
		"gold" : gold,
		"max_gold" : max_gold,
		"muon_pearls": muon_pearls,
		"max_muon_pearls": max_muon_pearls,
		"inventory" : inventory_resources_array,
	}
	save_game.store_line(to_json(node_data))
	save_game.close()

func load_inventory():
	var save_game = File.new()
	if not save_game.file_exists("user://Saves/%s/%s.save" % [WorldStats.save_block, get_name()]):
		return
	save_game.open("user://Saves/%s/%s.save" % [WorldStats.save_block, get_name()], File.READ)
	var node_data = parse_json(save_game.get_line())
	for i in node_data.keys():
		if i == "inventory":
			for index in len(node_data[i]):
				if node_data[i][index]["path"] != null:
					inventory[index] = ResourceLoader.load(node_data[i][index]["path"])
					inventory[index].quantity = node_data[i][index]["quantity"]
				else: 
					inventory[index] = null
				emit_signal("item_changed", [index])
			continue
		else:
			set(i, node_data[i])
	save_game.close()

var ItemResources = {
	"KEY": preload("res://Inventory/Items/Keys/Key.tres"),
	"MUON_PEARL": preload("res://Inventory/Items/Currencies/MuonPearl.tres"),
}

var ItemScenes = {
	"CONTAINER": preload("res://Inventory/Items/ItemContainer.tscn"),
	"POTION": preload("res://Inventory/Items/Potions/Potion.tscn"),
	"WEAPON": preload("res://Inventory/Items/Weapons/Weapon.tscn"),
	"KEY": preload("res://Inventory/Items/Keys/Key.tscn"),
	"PEARL": preload("res://Inventory/Items/Currencies/Pearl.tscn")
}
