extends StaticBody2D
class_name ForageNode

export (Resource) var world_item
export (Resource) var forage_item
export (float) var respawn_time = 300

onready var sprite = $Sprite
onready var shadow_sprite = $ShadowSprite
onready var interaction_zone = $InteractionZone
onready var collision_shape = $CollisionShape2D
onready var action = $InteractionZone/Actions/ForageAction
onready var timer = $Timer

func _ready():
	assert(forage_item)
	interaction_zone.connect("interaction_finished", self, "_on_interaction_finished")
	action.forage_item = forage_item
	if !File.new().file_exists(get_tree().get_nodes_in_group("World")[0].save_file):
		regrow()

func _on_interaction_finished(node):
	sprite.texture = null
	forage(respawn_time)

func _on_Timer_timeout():
	regrow()

func forage(time):
	sprite.texture = null
	shadow_sprite.visible = false
	collision_shape.set_deferred("disabled", true)
	interaction_zone.collision_shape.set_deferred("disabled", true)
	timer.start(time)

func regrow():
	sprite.texture = world_item.texture
	shadow_sprite.visible = true
	collision_shape.set_deferred("disabled", false)
	interaction_zone.collision_shape.set_deferred("disabled", false)

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"time_remaining" : timer.time_left,
		"class" : "ForageNode"
	}
	return save_dict
