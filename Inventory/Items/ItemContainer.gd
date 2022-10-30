extends Node2D

export (Resource) var drop_item = null
export (float) var drop_rate = 0

func _ready():
	randomize()
	if drop_item != null:
		if randf() <= drop_rate:
			drop_item(drop_item)
	else:
		var drop_result = randf()
		if drop_result <= 0.25:
			drop_item(Inventory.ItemResources.MAJOR_RED)
		elif drop_result > 0.25 && drop_result <= 0.5:
			drop_item(Inventory.ItemResources.RED)
		elif drop_result > 0.5:
			drop_item(Inventory.ItemResources.MINOR_RED)

func drop_item(resource: Resource):
	var item_type = resource.type
	match item_type:
		"potion":
			var new_potion = Inventory.ItemScenes.POTION.instance()
			add_child(new_potion)
			new_potion.global_position = global_position
			new_potion.set_item_resource(resource)

