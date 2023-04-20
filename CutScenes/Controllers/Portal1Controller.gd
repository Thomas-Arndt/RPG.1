extends "res://CutScenes/Controllers/CutSceneController.gd"


func package_choreography():
	choreography.append([ENTER, Vector2(80, 670)])
	choreography.append([CUSTOM, "initialize", []])
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
		"initialize":
			actor.get_parent().move_child(actor, 0)
			actor.match_dimension(WorldStats.DIMENSION)
			run_cut_scene()
