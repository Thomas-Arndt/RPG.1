extends Node2D

onready var green_dimension = $GreenDimension
onready var red_dimension = $RedDimension

func _ready():
	WorldStats.connect("shift_dimension", self, "match_dimension")
	match_dimension(WorldStats.DIMENSION)
	
func match_dimension(dimension):
	match dimension:
		WorldStats.Dimensions.Green:
			green_dimension.visible = true
			red_dimension.visible = false
		WorldStats.Dimensions.Red:
			green_dimension.visible = false
			red_dimension.visible = true
