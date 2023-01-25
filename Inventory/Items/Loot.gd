extends Area2D

export (Resource) var item_resource

onready var sprite = $Sprite

func _ready():
	if item_resource != null:
		sprite.texture = item_resource.texture

func on_body_entered(body):
		Inventory.pick_up_item(item_resource)
		get_parent().queue_free()

func set_item_resource(resource: Resource):
	item_resource = resource;
	sprite.texture = item_resource.texture
