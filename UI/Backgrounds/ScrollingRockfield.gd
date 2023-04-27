extends Node2D

export var depth : bool = true

onready var texture_fg : Node = $TextureRectFG
onready var texture_bg : Node = $TextureRectBG

func _ready():
	if depth:
		texture_fg.visible = true
		texture_bg.visible = false
	else:
		texture_bg.visible = true
		texture_fg.visible = false
