extends StaticBody2D

func _ready():
	for child in get_children():
		if child is AnimatedSprite:
			child.play()
