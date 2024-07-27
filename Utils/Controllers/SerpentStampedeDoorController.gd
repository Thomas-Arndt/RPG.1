extends Area2D

var stampede_controller: Node = null
var toggle: bool = true
var open_doors: Array = []

func _ready():
	stampede_controller = get_tree().get_nodes_in_group("SerpentStampedeController")[0]
	assert(stampede_controller)
	SignalBus.connect("red_blue_switch_state_changed", self, "on_Red_Blue_Switch_interaction")

func _on_SerpentStampedeDoorController_area_entered(area):
	if toggle:
		if !open_doors.has(str(stampede_controller.group_1_index)):
			open_doors.append(str(stampede_controller.group_1_index))
			SignalBus.emit_signal("event_switch", str(stampede_controller.group_1_index), "open")	
		if !open_doors.has(str(stampede_controller.group_2_index)):		
			open_doors.append(str(stampede_controller.group_2_index))
			SignalBus.emit_signal("event_switch", str(stampede_controller.group_2_index), "open")	
	else:
		close_all_doors()
	toggle = !toggle

func on_Red_Blue_Switch_interaction(code, state, states):
	if state == states.RED:
		close_door(code)
	elif state == states.BLUE:
		open_door(code)

func open_door(door_code):
	SignalBus.emit_signal("event_switch", door_code, "open")
	open_doors.append(door_code)

func close_door(door_code):
	SignalBus.emit_signal("event_switch", door_code, "close")
	var temp_array = []
	for door in open_doors:
		if door != door_code:
			temp_array.append(door)
	open_doors = temp_array

func close_all_doors():
	while len(open_doors) > 0:
		SignalBus.emit_signal("event_switch", open_doors.pop_back(), "close")	
