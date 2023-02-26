extends StaticBody2D

export var show_green: bool = true
export var show_red: bool = true

onready var red_sprite = $RedSprite
onready var green_sprite = $GreenSprite
onready var shadow_sprite = $ShadowSprite
onready var collision_shape = $CollisionShape2D

func _ready():
	match_dimension(WorldStats.DIMENSION)
	WorldStats.connect("dimension_shift", self, "match_dimension")

func match_dimension(state):
	if state == WorldStats.Dimensions.Red and show_red == true:
		red_sprite.visible = true
		green_sprite.visible = false
		shadow_sprite.visible = true
		collision_shape.set_deferred("disabled", false)
	elif state == WorldStats.Dimensions.Red and show_red == false:
		red_sprite.visible = false
		green_sprite.visible = false
		shadow_sprite.visible = false
		collision_shape.set_deferred("disabled", true)
	elif state == WorldStats.Dimensions.Green and show_green == true:
		red_sprite.visible = false
		green_sprite.visible = true
		shadow_sprite.visible = true
		collision_shape.set_deferred("disabled", false)
	elif state == WorldStats.Dimensions.Green and show_green == false:
		red_sprite.visible = false
		green_sprite.visible = false
		shadow_sprite.visible = false
		collision_shape.set_deferred("disabled", true)

