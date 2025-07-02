extends Node2D

const item_scene = preload("res://Inventory/Items/ItemContainer.tscn")

export var item_resource : Resource = null
export var throw_height : float = 20
export var active : bool = true

onready var pivot = $Pivot
onready var radius = $Pivot/Radius
onready var tween = $Tween

var item_container = null
var new_item = null

func _ready():
	item_container = get_parent()
	assert(item_container)
	assert(item_scene)

func throw_item(direction = null, distance = null):
	if active:
		var pivot_rotation = randi() % 360
		var pivot_radius = rand_range(20, 40)
		if not direction == null:
			pivot_rotation = direction
		if not distance == null:
			pivot_radius = distance
		radius.position.y += pivot_radius
		pivot.rotation_degrees = pivot_rotation
		new_item = item_scene.instance()
		new_item.drop_item = item_resource
		new_item.drop_rate = 1
		item_container.add_child(new_item)
		new_item.global_position = global_position
		animate_throw(radius.global_position)

func animate_arc(progress):
	if is_instance_valid(new_item):
		var sprite_height = (throw_height * pow(sin(progress * PI), 0.7))+9
		var shadow_scale = 1.0 - sprite_height / throw_height * 0.5
		new_item.global_position.y = new_item.global_position.y - sprite_height
		new_item.new_item.shadow_sprite.scale = Vector2(shadow_scale, shadow_scale)

func animate_throw(destination):
	tween.interpolate_property(new_item, "global_position", global_position, destination, 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_method(self, "animate_arc", 0, 1, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()


func _on_Tween_tween_all_completed():
	queue_free()
