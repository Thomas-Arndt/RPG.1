extends Area2D

export (Resource) var item_resource

onready var sprite = $Sprite

func _ready():
	if item_resource != null:
		sprite.texture = item_resource.texture

func on_body_entered(body):
	var existing_index = null
	for i in len(Inventory.inventory):
		if Inventory.inventory[i] is Item and Inventory.inventory[i].name == item_resource.name:
			existing_index = i
	var new_index = 0
	while (Inventory.inventory[new_index] != null && new_index < len(Inventory.inventory)):
		new_index += 1
	if existing_index != null:
		Inventory.pick_up_item(existing_index, item_resource)
		get_parent().queue_free()
	elif (new_index < len(Inventory.inventory)):
		Inventory.pick_up_item(new_index, item_resource)
		get_parent().queue_free()

func set_item_resource(resource: Resource):
	item_resource = resource;
	sprite.texture = item_resource.texture
