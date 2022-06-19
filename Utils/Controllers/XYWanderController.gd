extends Node2D

export(int) var wander_range = 32
export(String) var axis = "X"

onready var start_position = global_position
onready var target_position = global_position

onready var timer = $Timer

var reverse:bool = false

func _ready():
	update_target_position()
	
func update_target_position():
	if axis == "X":
		if reverse:
			target_position.x = start_position.x
		else:
			target_position.x = start_position.x + wander_range
	elif axis == "Y":
		if reverse:
			target_position.y = start_position.y
		else:
			target_position.y = start_position.y + wander_range
	reverse = !reverse

func get_time_left():
	return timer.time_left

func start_wander_timer(duration):
	timer.start(duration)

func _on_Timer_timeout():
	update_target_position()
