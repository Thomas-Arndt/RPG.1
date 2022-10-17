extends Node2D

signal arrived

onready var detection_zones = $DetectionZones
onready var timer = $Timer
onready var start_position = global_position
onready var target_position = Vector2.ZERO

var target_node: Node = null
var previous_node: Node = null

func _ready():
	update_target_position()
	randomize()
		
func update_target_position():
	var available_nodes: Array = []
	if len(detection_zones.get_children()) > 0:
		for detection_zone in detection_zones.get_children():
			if detection_zone != previous_node:
				available_nodes.append(detection_zone)
		var length = len(available_nodes)
		var next_node_index = randi() % length
		target_node = available_nodes[next_node_index]
		previous_node = target_node
		target_position = target_node.global_position

func can_see_unit():
	for detection_zone in detection_zones.get_children():
		if detection_zone.get_child(0).can_interact() and detection_zone == target_node:
			emit_signal("arrived")
			return true
	return false

func get_time_left():
	return timer.time_left

func start_timer(duration):
	target_node = null
	timer.start(duration)

func set_position(position):
	global_position = position
	
func monitorable_on():
	for child in detection_zones.get_children():
		child.get_child(0).monitorable = true

func monitorable_off():
	for child in detection_zones.get_children():
		child.get_child(0).monitorable = false

func _on_Timer_timeout():
	update_target_position()
