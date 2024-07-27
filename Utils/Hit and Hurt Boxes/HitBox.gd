extends Area2D
class_name HitBox

export var damage = 1
export var knockback_vector: Vector2 = Vector2.ZERO

func set_knockback_vector(target):
	knockback_vector = global_position.direction_to(target.global_position)
