extends "res://Utils/Controllers/CutSceneController.gd"


func package_choreography():
	choreography.append([ENTER, Vector2.ZERO])
	choreography.append([CUSTOM, "open_and_hold", []])
	choreography.append([WAIT, 4])
	choreography.append([CUSTOM, "close", []])
	choreography.append([EXIT])
	choreography.append([DELETE_ACTOR])


func custom_actions(action_name, args):
	match action_name:
		"open_and_hold":
			toggle_visible_on()
			actor.open_and_hold()
			run_cut_scene()
		"close":
			actor.close()
			run_cut_scene()