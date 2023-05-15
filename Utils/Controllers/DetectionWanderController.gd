extends Node2D

signal arrived

export var random : bool = false

onready var detection_zones = $DetectionZones
onready var timer = $Timer
onready var start_position = global_position
onready var target_position = Vector2.ZERO

var target_node: Node = null
var previous_node: Node = null
var sequential_index : int = 0

func _ready():
	update_target_position()
	if random:
		randomize()
		
func update_target_position():
	var available_nodes: Array = []
	if len(detection_zones.get_children()) > 0:
		if random:
			for detection_zone in detection_zones.get_children():
				if detection_zone != previous_node:
					available_nodes.append(detection_zone)
			var length = len(available_nodes)
			var next_node_index = randi() % length
			target_node = available_nodes[next_node_index]
			previous_node = target_node
		else:
			target_node = detection_zones.get_child(sequential_index)
			if sequential_index < detection_zones.get_child_count() - 1:
				sequential_index += 1
			else:
				sequential_index = 0
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

func set_position(pos):
	global_position = pos
	
func monitorable_on():
	for child in detection_zones.get_children():
		child.get_child(0).monitorable = true

func monitorable_off():
	for child in detection_zones.get_children():
		child.get_child(0).monitorable = false

func _on_Timer_timeout():
	update_target_position()

func add_detection_zone(position):
	var new_detection_zone = ResourceLoader.load("res://Utils/Overlap/DetectionZone.tscn").instance()
	new_detection_zone.global_position = position
	detection_zones.add_child(new_detection_zone)
