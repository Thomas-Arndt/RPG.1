extends Node

signal dimension_shift(value)

export var DIMENSION : int = Dimensions.Green

var player_spawn_vector: Vector2 = Vector2(270, 165)
var player_spawn_direction: Vector2 = Vector2.DOWN

var save_block : String = "0"

func set_dimension(value : int):
	DIMENSION = value
	emit_signal("dimension_shift", DIMENSION)

func get_dimension() -> int:
	return DIMENSION

enum Dimensions {
	Red,
	Green,
	Between,
}
