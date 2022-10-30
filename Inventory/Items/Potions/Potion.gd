extends Area2D

export (Resource) var item_resource

onready var sprite = $Sprite

func _ready():
	if item_resource != null:
		sprite.texture = item_resource.texture

func _on_Potion_body_entered(body):
	var index = 0
	while (Inventory.inventory[index] != null && index < len(Inventory.inventory)):
		index += 1
	if (index < len(Inventory.inventory)):
		Inventory.pick_up_item(index, item_resource)
		get_parent().queue_free()

func set_item_resource(resource: Resource):
	item_resource = resource;
	sprite.texture = item_resource.texture
