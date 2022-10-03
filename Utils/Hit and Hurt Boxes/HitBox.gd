extends Area2D

export var damage = 1
var knockback_vector = Vector2.ZERO

func set_knockback_vector(target):
	knockback_vector = global_position.direction_to(target.global_position)
