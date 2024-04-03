extends "res://CutScenes/Controllers/CutSceneController.gd"

onready var bat1 = get_node("/root/Game/A9/YSort/NPCs/Bat")
onready var bat2 = get_node("/root/Game/A9/YSort/NPCs/Bat2")

func package_choreography():
	choreography.append([PAUSE_FOR_DIALOGUE, []])
	choreography.append([WAIT, 1.7])
	choreography.append([CUSTOM, "BAT_ONE_DIE", []])
	choreography.append([PAUSE_FOR_DIALOGUE, []])	
	choreography.append([WAIT, 2.4])
	choreography.append([CUSTOM, "BAT_TWO_DIE", []])

func custom_actions(action_name, args):
	match action_name:
		"BAT_ONE_DIE":
			bat1._on_Stats_no_health()
			run_cut_scene()
		"BAT_TWO_DIE":
			bat2._on_Stats_no_health()
			run_cut_scene()
