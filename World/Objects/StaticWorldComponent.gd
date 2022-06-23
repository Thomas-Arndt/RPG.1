extends StaticBody2D

onready var red_sprite = $RedSprite
onready var green_sprite = $GreenSprite

func _ready():
	match_dimension(WorldStats.DIMENSION)
	WorldStats.connect("dimension_shift", self, "match_dimension")

func match_dimension(state):
	if state == true:
		red_sprite.visible = true
		green_sprite.visible = false
	else:
		red_sprite.visible = false
		green_sprite.visible = true
