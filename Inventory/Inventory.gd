extends Node

signal gold_changed(value)
signal max_gold_changed(value)
signal item_changed(indices)

var drag_data = null

var gold: int = 0 setget set_gold
var max_gold: int = 99 setget set_max_gold

var sword  = preload("res://Inventory/Items/Weapons/Sword.tres")

export (Array, Resource) var inventory: Array = [
	null, null, null, null, 
	null, null, null, null, 
	null, null, null, null, 
	null, null, null, null, 
	null, null, null, null
]

func _ready():
	pick_up_item(3, sword)

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

func pick_up_item(item_index, item):
	var previousItem = inventory[item_index]
	inventory[item_index] = item.duplicate()
	emit_signal("item_changed", [item_index])
	return previousItem

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

func make_items_unique():
	var unique_items: Array = []
	for item in inventory:
		if item is Item:
			unique_items.append(item.duplicate())
		else:
			unique_items.append(null)
	inventory = unique_items

func drop_item_container(pos: Vector2, parent_node: Node):
	var item_container = ItemScenes.CONTAINER.instance()
	item_container.global_position = Vector2(pos.x, pos.y+8)
	parent_node.add_child(item_container)



var ItemResources = {
	"MINOR_RED": preload("res://Inventory/Items/Potions/Red/red_minor.tres"),
	"RED": preload("res://Inventory/Items/Potions/Red/red_normal.tres"),
	"MAJOR_RED": preload("res://Inventory/Items/Potions/Red/red_major.tres"),
	"SUPER_RED": preload("res://Inventory/Items/Potions/Red/red_super.tres"),
	"SWORD": preload("res://Inventory/Items/Weapons/Sword.tres"),
	"KEY": preload("res://Inventory/Items/Keys/Key.tres"),
}

var ItemScenes = {
	"CONTAINER": preload("res://Inventory/Items/ItemContainer.tscn"),
	"POTION": preload("res://Inventory/Items/Potions/Potion.tscn"),
	"WEAPON": preload("res://Inventory/Items/Weapons/Weapon.tscn"),
	"KEY": preload("res://Inventory/Items/Keys/Key.tscn"),
}
