extends KinematicBody2D

export var movement_locked : bool = false

var effect_applied : bool = false
var initial_position : Vector2 = Vector2.ZERO

func _ready():
	initial_position = global_position

func apply_effect():
	effect_applied = true

func remove_effect():
	effect_applied = false

func move(velocity):
	if !movement_locked:
		move_and_slide(velocity)
