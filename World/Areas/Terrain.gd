extends Node2D

onready var green_dimension = $GreenDimension
onready var red_dimension = $RedDimension

func _ready():
	WorldStats.connect("dimension_shift", self, "shift_dimension")
	
func shift_dimension(dimension):
	green_dimension.visible = !dimension
	red_dimension.visible = dimension
