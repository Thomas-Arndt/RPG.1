extends Area2D

export (Resource) var item_resource

onready var sprite = $Sprite
onready var shadow_sprite = $ShadowSprite

func _ready():
	if item_resource != null:
		sprite.texture = item_resource.texture

func on_body_entered(body):
	if body == get_tree().get_nodes_in_group("Player")[0]:
		Inventory.pick_up_item(item_resource)
		get_parent().queue_free()

func set_item_resource(resource: Resource):
	item_resource = resource;
	sprite.texture = item_resource.texture
