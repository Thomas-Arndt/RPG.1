extends Area2D
class_name PortalNode

export var is_red : bool = false
export var is_green : bool = true
export var show_both : bool = false
export var active : bool = true
export (String) var destination_reference
export (Vector2) var from_red_exit_location = Vector2.ZERO
export (Vector2) var from_red_exit_direction = Vector2.DOWN
export (Vector2) var from_green_exit_location = Vector2.ZERO
export (Vector2) var from_green_exit_direction = Vector2.DOWN
export (Vector2) var from_between_exit_location = Vector2.ZERO
export (Vector2) var from_between_exit_direction = Vector2.DOWN

onready var anim_player = $AnimationPlayer
onready var green_sprite = $GreenSprite
onready var red_sprite = $RedSprite
onready var collision_shape = $CollisionShape2D

func _ready():
	WorldStats.connect("dimension_shift", self, "match_dimension")
	match_dimension(WorldStats.DIMENSION)
	if show_both:
		anim_player.play("holding")
	else:
		open_and_hold()
		

func match_dimension(dimension):
	if (dimension == WorldStats.Dimensions.Red or show_both) and is_red:
		green_sprite.visible = false
		red_sprite.visible = true
		collision_shape.set_deferred("disabled", false)
	elif (dimension == WorldStats.Dimensions.Green or show_both) and is_green:
		green_sprite.visible = true
		red_sprite.visible = false
		collision_shape.set_deferred("disabled", false)
	else:
		self.visible = false
		collision_shape.set_deferred("disabled", true)
		

func open_and_hold():
	anim_player.queue("open")
	anim_player.queue("holding")

func close():
	anim_player.stop()
	anim_player.play("close")

func _on_Portal_body_entered(body):
	if active:
		match WorldStats.get_dimension():
			WorldStats.Dimensions.Red:
				WorldStats.set_dimension(WorldStats.Dimensions.Between)
				WorldStats.player_spawn_vector = from_red_exit_location
				WorldStats.player_spawn_direction = from_red_exit_direction
			WorldStats.Dimensions.Green:
				WorldStats.set_dimension(WorldStats.Dimensions.Between)
				WorldStats.player_spawn_vector = from_green_exit_location
				WorldStats.player_spawn_direction = from_green_exit_direction
			WorldStats.Dimensions.Between:
				if is_red:
					WorldStats.set_dimension(WorldStats.Dimensions.Red)
				elif is_green:
					WorldStats.set_dimension(WorldStats.Dimensions.Green)
				WorldStats.player_spawn_vector = from_between_exit_location
				WorldStats.player_spawn_direction = from_between_exit_direction
		SignalBus.emit_signal("scene_link_entered", destination_reference)
