extends TileMap

func _ready():
	WorldStats.connect("dimension_shift", self, "match_dimension")
	match_dimension(WorldStats.DIMENSION)
	
func match_dimension(state):
	if state == WorldStats.Dimensions.Green:
		visible = true
	else:
		visible = false
