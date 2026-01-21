extends StaticBody2D
class_name ForageLayerNode

signal gathered

export (Resource) var world_item
export (Resource) var forage_item
export (float) var respawn_time = 15

onready var sprite = $Sprite
onready var shadow_sprite = $ShadowSprite
onready var interaction_zone = $InteractionZone
onready var collision_shape = $CollisionShape2D
onready var action = $InteractionZone/Actions/ForageAction
onready var timer = $Timer

var available = true
var active = false

func _ready():
	assert(forage_item)
	interaction_zone.connect("interaction_finished", self, "_on_interaction_finished")
	action.forage_item = forage_item

func _on_interaction_finished(node):
	sprite.texture = null
	forage(respawn_time)
	emit_signal("gathered")

func _on_Timer_timeout():
	available = true

func forage(time):
	disable_node()
	timer.start(time)

func grow():
	sprite.texture = world_item.texture
	shadow_sprite.visible = true
	collision_shape.set_deferred("disabled", false)
	interaction_zone.collision_shape.set_deferred("disabled", false)
	available = false
	active = true

func is_available() -> bool:
	return available
	
func disable_node():
	sprite.texture = null
	shadow_sprite.visible = false
	collision_shape.set_deferred("disabled", true)
	interaction_zone.collision_shape.set_deferred("disabled", true)
	active = false
	
func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"time_remaining" : timer.time_left,
		"available" : available,
		"active" : active,
		"class" : "ForageLayerNode"
	}
	return save_dict
