extends Node2D

signal arrived

onready var detection_zone_groups = $DetectionZoneGroups
onready var timer = $Timer
onready var start_position = global_position
onready var target_position = Vector2.ZERO

var detection_zones = []
var target_node: Node = null
var last_group_index = null
var zone_sequence: Array = []
var length = 0

var group_1_index: int
var group_2_index: int

func _ready():
	length = len(detection_zone_groups.get_children())
	for group in detection_zone_groups.get_children():
		for zone in group.get_children():
			detection_zones.append(zone)
	randomize()
	set_sequence()
	zone_sequence.pop_front()
	update_target_position()
		
func update_target_position():
	target_node = zone_sequence.pop_front()
	target_position = target_node.global_position
	if len(zone_sequence) == 0:
		set_sequence()
	
func set_sequence():
	group_1_index = randi() % length
	while group_1_index == last_group_index:
		group_1_index = randi() % length
	group_2_index = randi() % length
	while group_2_index == group_1_index:
		group_2_index = randi() % length
	last_group_index = group_2_index
	var group_1 = detection_zone_groups.get_child(group_1_index)	
	var group_2 = detection_zone_groups.get_child(group_2_index)	
	zone_sequence.append(group_1.get_child(0))
	zone_sequence.append(group_1.get_child(1))
	zone_sequence.append(group_2.get_child(1))
	zone_sequence.append(group_2.get_child(0))

func can_see_unit():
	for detection_zone in detection_zones:
		if detection_zone.get_child(0).can_interact() and detection_zone == target_node and detection_zone.get_child(0).target.get_parent() == get_parent():
			emit_signal("arrived")
			return true
	return false

func set_position(pos):
	global_position = pos









func get_time_left():
	return timer.time_left

func start_timer(duration):
	target_node = null
	timer.start(duration)

	
func monitorable_on():
	for child in detection_zones.get_children():
		child.get_child(0).monitorable = true

func monitorable_off():
	for child in detection_zones.get_children():
		child.get_child(0).monitorable = false

func _on_Timer_timeout():
	update_target_position()
