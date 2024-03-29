extends StaticBody2D
class_name MineralNode

export (Resource) var world_item
export (Resource) var mine_item
export (int) var mine_quantity = 1
export (float) var respawn_time = 300

onready var sprite = $Sprite
onready var shadow_sprite = $ShadowSprite
onready var interaction_zone = $InteractionZone
onready var collision_shape = $CollisionShape2D
onready var action = $InteractionZone/Actions/MineAction
onready var timer = $Timer

var depleted_sprite = preload("res://World/Objects/Minerals/MinedVein.png")

func _ready():
	assert(mine_item)
	replenish()
	if !File.new().file_exists(get_tree().get_nodes_in_group("World")[0].save_file):
		replenish()
	interaction_zone.connect("interaction_finished", self, "_on_interaction_finished")
	action.mine_item = mine_item

func _on_interaction_finished(node):
	depleted(respawn_time)

func _on_Timer_timeout():
	replenish()

func depleted(time):
	sprite.texture = depleted_sprite
	interaction_zone.collision_shape.set_deferred("disabled", true)
	timer.start(time)

func replenish():
	action.mine_quantity = mine_quantity
	sprite.texture = world_item.texture
	interaction_zone.collision_shape.set_deferred("disabled", false)

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"time_remaining" : timer.time_left,
		"class" : "MineralNode"
	}
	return save_dict
