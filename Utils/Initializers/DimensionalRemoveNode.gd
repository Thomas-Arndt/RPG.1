extends Node

export var apply_red : bool
export var apply_green : bool

func _ready():
	if apply_red and WorldStats.DIMENSION == WorldStats.Dimensions.Red:
		get_parent().queue_free()
	elif apply_green and WorldStats.DIMENSION == WorldStats.Dimensions.Green:
		get_parent().queue_free()
