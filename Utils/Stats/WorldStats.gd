extends Node

signal dimension_shift(state)

export(bool) var DIMENSION = false

var room_stack: Array = []

var player_spawn_vector: Vector2 = Vector2(270, 165)
var player_spawn_direction: Vector2 = Vector2.DOWN

func shift_dimension():
	DIMENSION = !DIMENSION
	emit_signal("dimension_shift", DIMENSION)
	
func add_room_to_stack(room):
	room_stack.append(room)

func remove_room_from_stack():
	return room_stack.pop_back()
	
func peek_top_of_room_stack():
	return room_stack[len(room_stack)-1]



