extends Node2D

export (Resource) var drop_item = null
export (float) var drop_rate = 0

var new_item = null

func _ready():
	assert(drop_item)
	randomize()
	drop_item(drop_item)

func drop_item(resource: Resource):
	var item_type = resource.type
	match item_type:
		"potion":
			new_item = Inventory.ItemScenes.POTION.instance()
			insert_item(resource)
		"weapon":
			new_item = Inventory.ItemScenes.WEAPON.instance()
			insert_item(resource)
		"key":
			new_item = Inventory.ItemScenes.KEY.instance()
			insert_item(resource)
		"pearl":
			new_item = Inventory.ItemScenes.PEARL.instance()
			insert_item(resource)

func insert_item(resource):
	add_child(new_item)
	new_item.global_position = global_position
	new_item.set_item_resource(resource)
