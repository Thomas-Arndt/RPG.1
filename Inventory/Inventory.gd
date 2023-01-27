extends Node

signal gold_changed(value)
signal max_gold_changed(value)
signal item_changed(indices)

var drag_data = null

var gold: int = 0 setget set_gold
var max_gold: int = 99 setget set_max_gold

var sword  = preload("res://Inventory/Items/Weapons/Swords/Sword.tres")
var boots = preload("res://Inventory/Items/Boots.tres")

export (Array, Resource) var inventory: Array = [
	null, null, null, null, 
	null, null, null, null, 
	null, null, null, null, 
	null, null, null, null, 
	null, null, null, null
]

func _ready():
	pick_up_item(sword, 1, 3)
	pick_up_item(boots, 1, 2)

func set_gold(value):
	gold = value
	emit_signal("gold_changed", value)

func change_gold(value):
	gold += value
	gold = clamp(gold, 0, max_gold)
	emit_signal("gold_changed", value)
	
func set_max_gold(value):
	max_gold = value
	emit_signal("max_gold_changed", value)

func pick_up_item(item, quantity=1, index = null):
	var item_index = 0
	if index != null:
		item_index = index
	else:
		item_index = pick_up_index(item)
	if inventory[item_index] == null:
		var previousItem = inventory[item_index]
		inventory[item_index] = item.duplicate()
		inventory[item_index].quantity = quantity
		emit_signal("item_changed", [item_index])
		return previousItem
	else:
		inventory[item_index].quantity += item.quantity
		emit_signal("item_changed", [item_index])
		return inventory[item_index]

func set_item(item_index, item):
	var previousItem = inventory[item_index]
	inventory[item_index] = item
	emit_signal("item_changed", [item_index])
	return previousItem
	
func swap_items(item_index, target_item_index):
	var targetItem = inventory[target_item_index]
	var item = inventory[item_index]
	inventory[target_item_index] = item
	inventory[item_index] = targetItem
	emit_signal("item_changed", [item_index, target_item_index])
	
func remove_item(item_index):
	var previousItem = inventory[item_index]
	inventory[item_index] = null
	emit_signal("item_changed", [item_index])
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




var ItemResources = {
	"MINOR_RED": preload("res://Inventory/Items/Potions/Red/red_minor.tres"),
	"RED": preload("res://Inventory/Items/Potions/Red/red_normal.tres"),
	"MAJOR_RED": preload("res://Inventory/Items/Potions/Red/red_major.tres"),
	"SWORD": preload("res://Inventory/Items/Weapons/Swords/Sword.tres"),
	"BOOTS": preload("res://Inventory/Items/Boots.tres"),
	"KEY": preload("res://Inventory/Items/Keys/Key.tres"),
}

var ItemScenes = {
	"CONTAINER": preload("res://Inventory/Items/ItemContainer.tscn"),
	"POTION": preload("res://Inventory/Items/Potions/Potion.tscn"),
	"WEAPON": preload("res://Inventory/Items/Weapons/Weapon.tscn"),
	"KEY": preload("res://Inventory/Items/Keys/Key.tscn"),
}
