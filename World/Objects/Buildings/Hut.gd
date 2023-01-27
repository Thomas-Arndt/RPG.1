extends StaticBody2D

signal set_Scene_Link_Active(state)

export var show_green: bool = true
export var show_red: bool = true

onready var red_sprite = $RedSprite
onready var green_sprite = $GreenSprite
onready var shadow_sprite = $ShadowSprite
onready var collision_shape = $CollisionPolygon2D

func _ready():
	$Shrub.show_red = show_red
	$Shrub2.show_red = show_red
	$Shrub.show_green = show_green
	$Shrub2.show_green = show_green
	match_dimension(WorldStats.DIMENSION)
	WorldStats.connect("dimension_shift", self, "match_dimension")
	
func match_dimension(state):
	if state == true and show_red == true:
		red_sprite.visible = true
		green_sprite.visible = false
		shadow_sprite.visible = true
		collision_shape.set_deferred("disabled", false)
		emit_signal("set_Scene_Link_Active", true)
	elif state == true and show_red == false:
		red_sprite.visible = false
		green_sprite.visible = false
		shadow_sprite.visible = false
		collision_shape.set_deferred("disabled", true)
		emit_signal("set_Scene_Link_Active", false)
	elif state == false and show_green == true:
		red_sprite.visible = false
		green_sprite.visible = true
		shadow_sprite.visible = true
		collision_shape.set_deferred("disabled", false)
		emit_signal("set_Scene_Link_Active", true)
	elif state == false and show_green == false:
		red_sprite.visible = false
		green_sprite.visible = false
		shadow_sprite.visible = false
		collision_shape.set_deferred("disabled", true)
		emit_signal("set_Scene_Link_Active", false)
