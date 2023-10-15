extends Node2D

export var average_distance = 32
export var multiplier = 2

onready var target_position = global_position

onready var timer = $Timer
onready var landing_pad = $LandingPad

func _ready():
	randomize()
	if multiplier < 1:
		multiplier = 1
	update_target_position()
	
func update_target_position():
	apply_adjustments()
	if len(landing_pad.get_overlapping_bodies()) > 0:
		apply_adjustments()

func apply_adjustments():
	var player = get_tree().get_nodes_in_group("Player")[0]
	var direction = randi() % 4 + 1
	var coarse_adjustment = randi() % 3 + multiplier
	var fine_adjustment = (randi() % 6 + 1) + (randi() % 6 + 1) - 7
	match direction:
		1:
			target_position = Vector2((player.global_position.x + (average_distance * coarse_adjustment)+ fine_adjustment), player.global_position.y)
		2:
			target_position = Vector2(player.global_position.x, (player.global_position.y + (average_distance * coarse_adjustment) + fine_adjustment))			
		3:
			target_position = Vector2((player.global_position.x - (average_distance * coarse_adjustment) + fine_adjustment), player.global_position.y)			
		4:
			target_position = Vector2(player.global_position.x, (player.global_position.y - (average_distance * coarse_adjustment) + fine_adjustment))			
		
func get_time_left():
	return timer.time_left

func start_wander_timer(duration):
	timer.start(duration)

func _on_Timer_timeout():
	update_target_position()
