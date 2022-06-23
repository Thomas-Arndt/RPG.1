extends Node

signal dimension_shift(state)

export(bool) var DIMENSION = false

func shift_dimension():
	DIMENSION = !DIMENSION
	emit_signal("dimension_shift", DIMENSION)



