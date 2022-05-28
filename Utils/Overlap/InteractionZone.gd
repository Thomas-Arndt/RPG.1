extends Area2D

var test = null

func _process(delta):
	if WorldStats.DIMENSION == true:
		test = "Red Dimension Stuff on a Red Dimension Bulletin Board."
	else:
		test = "Green Dimenson Stuff on a Green Dimension Bulletin Board."

