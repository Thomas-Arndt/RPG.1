extends StaticBody2D
class_name MineRockNode

onready var sprite = $Sprite
onready var shadow_sprite = $ShadowSprite
onready var interaction_zone = $InteractionZone
onready var collision_shape = $CollisionShape2D
onready var action = $InteractionZone/Actions/MineRockAction

var mine_rock_effect = preload("res://Effects/ObjectEffects/RockEffect.tscn")
var active : bool = true

func _ready():
	interaction_zone.connect("interaction_finished", self, "_on_interaction_finished")
	action.connect("strike", self, "_on_Strike")

func _on_interaction_finished(node):
	strike()
	remove_rock()

func _on_Strike():
	strike()
	
func strike():
	var rock_effect = mine_rock_effect.instance()
	rock_effect.global_position = global_position
	get_parent().add_child(rock_effect)
	
func remove_rock():
	sprite.visible = false
	shadow_sprite.visible = false
	interaction_zone.collision_shape.set_deferred("disabled", true)
	collision_shape.set_deferred("disabled", true)
	active = false

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"active" : active,
		"class" : "MineRockNode"
	}
	return save_dict
