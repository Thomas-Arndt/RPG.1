extends "res://CutScenes/Controllers/CutSceneController.gd"

onready var bat1 = null
onready var bat2 = null
onready var bat = preload("res://Enemies/Bat.tscn")

func package_choreography():
	choreography.append([CUSTOM, "BAT_ONE_ENTER", []])
	choreography.append([CUSTOM, "BAT_TWO_ENTER", []])
	choreography.append([PAUSE_FOR_DIALOGUE, []])
	choreography.append([WAIT, 1.7])
	choreography.append([CUSTOM, "BAT_ONE_DIE", []])
	choreography.append([PAUSE_FOR_DIALOGUE, []])	
	choreography.append([WAIT, 2.4])
	choreography.append([CUSTOM, "BAT_TWO_DIE", []])

func custom_actions(action_name, args):
	match action_name:
		"BAT_ONE_DIE":
			bat1.leave_dimension()
			run_cut_scene()
		"BAT_TWO_DIE":
			bat2.leave_dimension()
			run_cut_scene()
		"BAT_ONE_ENTER":
			bat1 = bat.instance()
			bat1.state_machine_paused = true
			bat1.global_position = Vector2(500, -600)
			get_tree().get_nodes_in_group("Mobs")[0].add_child(bat1)
		"BAT_TWO_ENTER":
			bat2 = bat.instance()
			bat2.state_machine_paused = true
			bat2.global_position = Vector2(620, -600)
			get_tree().get_nodes_in_group("Mobs")[0].add_child(bat2)
