extends Node

signal dimension_shift(state)

export(bool) var DIMENSION = false

var player_spawn_vector: Vector2 = Vector2(270, 165)
var player_spawn_direction: Vector2 = Vector2.DOWN

var save_block : String = "0"

func shift_dimension():
	DIMENSION = !DIMENSION
	emit_signal("dimension_shift", DIMENSION)
