extends Sprite

export var show_green: bool = true
export var show_red: bool = true

func _ready():
	match_dimension(WorldStats.DIMENSION)
	WorldStats.connect("dimension_shift", self, "match_dimension")

func match_dimension(state):
	if state == WorldStats.Dimensions.Red and show_red == true:
		self.visible = true
	elif state == WorldStats.Dimensions.Red and show_red == false:
		self.visible = false
	elif state == WorldStats.Dimensions.Green and show_green == true:
		self.visible = true
	elif state == WorldStats.Dimensions.Green and show_green == false:
		self.visible = false
