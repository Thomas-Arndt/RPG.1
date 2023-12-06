extends StaticBody2D
class_name MineralNode

export (Resource) var mine_item
export (int) var mine_quantity = 1
export (float) var respawn_time = 300

onready var sprite = $Sprite
onready var shadow_sprite = $ShadowSprite
onready var interaction_zone = $InteractionZone
onready var collision_shape = $CollisionShape2D
onready var action = $InteractionZone/Actions/MineAction
onready var timer = $Timer

func _ready():
	assert(mine_item)
	replenish()
	if !File.new().file_exists(get_tree().get_nodes_in_group("World")[0].save_file):
		replenish()
	interaction_zone.connect("interaction_finished", self, "_on_interaction_finished")

func _on_interaction_finished(node):
	mine(respawn_time)

func _on_Timer_timeout():
	replenish()

func mine(time):
	sprite.texture = null
	shadow_sprite.visible = false
	collision_shape.set_deferred("disabled", true)
	interaction_zone.collision_shape.set_deferred("disabled", true)
	timer.start(time)

func replenish():
	action.mine_quantity = mine_quantity
	sprite.texture = mine_item.texture
	shadow_sprite.visible = true
	collision_shape.set_deferred("disabled", false)
	interaction_zone.collision_shape.set_deferred("disabled", false)

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"time_remaining" : timer.time_left
	}
	return save_dict
