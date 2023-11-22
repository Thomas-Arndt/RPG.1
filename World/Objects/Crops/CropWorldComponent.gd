extends StaticBody2D
class_name CropNode


onready var sprite = $Sprite
onready var shadow_sprite = $ShadowSprite
onready var interaction_zone = $InteractionZone
onready var collision_shape = $CollisionShape2D
onready var timer = $Timer

export (Resource) var crop
export (Texture) var growth_sprite_sheet
export (int) var current_stage = stages.SEED
export (float) var growth_stage_time = 300.0
export (int) var harvest_min = 1
export (int) var harvest_max = 3

enum stages {
	SEED,
	SPROUT,
	VEGETATIVE,
	FRUIT,
	RIPE,
}

var location = Vector2.ZERO
var action : Node = null

func _ready():
	assert(crop)
	randomize()
	sprite.texture = growth_sprite_sheet
	location = global_position
	interaction_zone.connect("interaction_finished", self, "_on_interaction_finished")
	action = interaction_zone.Actions.get_children()[0]
	set_harvest_item()
	if !File.new().file_exists(get_tree().get_nodes_in_group("World")[0].save_file):
		sow_seeds()
	
func progress_growth():
	match current_stage:
		stages.SEED:
			current_stage = stages.SPROUT
		stages.SPROUT:
			current_stage = stages.VEGETATIVE
		stages.VEGETATIVE:
			current_stage = stages.FRUIT
		stages.FRUIT:
			current_stage = stages.RIPE
	set_growth_stage(current_stage)
	get_tree().get_nodes_in_group("World")[0].save_scene()
	timer.start(growth_stage_time)

func set_growth_stage(stage):
	if stage == stages.SEED:
		sprite.position = Vector2(0, 11)
		global_position.y = location.y -16
	else:
		sprite.position = Vector2(0, -5)
		global_position.y = location.y
	match stage:
		stages.SEED:
			sprite.region_rect = Rect2(64, 0, 16, 16)
			shadow_sprite.set_deferred("visible", false)
			collision_shape.set_deferred("disabled", true)
		stages.SPROUT:
			sprite.region_rect = Rect2(48, 0, 16, 16)
			shadow_sprite.set_deferred("visible", true)
			collision_shape.set_deferred("disabled", false)
			shadow_sprite.scale = Vector2(0.5, 0.5)
			collision_shape.scale = Vector2(0.5, 0.5)
		stages.VEGETATIVE:
			sprite.region_rect = Rect2(32, 0, 16, 16)
			shadow_sprite.set_deferred("visible", true)
			collision_shape.set_deferred("disabled", false)
			shadow_sprite.scale = Vector2(0.75, 0.75)
			collision_shape.scale = Vector2(0.75, 0.75)
		stages.FRUIT:
			sprite.region_rect = Rect2(16, 0, 16, 16)
			shadow_sprite.set_deferred("visible", true)
			collision_shape.set_deferred("disabled", false)
			shadow_sprite.scale = Vector2(1, 1)
			collision_shape.scale = Vector2(1, 1)
		stages.RIPE:
			sprite.region_rect = Rect2(0, 0, 16, 16)
			shadow_sprite.set_deferred("visible", true)
			collision_shape.set_deferred("disabled", false)
			shadow_sprite.scale = Vector2(1, 1)
			collision_shape.scale = Vector2(1, 1)
			action.set_active(true)

func start_growing(time):
	timer.start(time)
	
func sow_seeds():
	current_stage = stages.SEED
	set_growth_stage(current_stage)
	timer.start(growth_stage_time + randf() * (growth_stage_time * 0.33))

func _on_Timer_timeout():
	progress_growth()

func _on_interaction_finished(node):
	if current_stage == stages.RIPE:
		sow_seeds()
		get_tree().get_nodes_in_group("World")[0].save_scene()
	
func set_harvest_item():
	action.set_harvest_item(crop)

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"time_remaining" : timer.time_left,
		"current_stage": current_stage,
	}
	return save_dict
