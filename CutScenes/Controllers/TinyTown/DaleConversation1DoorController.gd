extends "res://CutScenes/Controllers/CutSceneController.gd"

func package_choreography():
	choreography.append([ENTER, Vector2.ZERO])
	choreography.append([PAUSE_FOR_DIALOGUE])
	choreography.append([CUSTOM, "OPENDOOR", []])
	choreography.append([WAIT, 1.5])
	choreography.append([CUSTOM, "CLOSEDOOR", []])
	choreography.append([RELEASE_PLAYER])
	choreography.append([RELEASE_ACTOR])

func custom_actions(action_name, args):
	match action_name:
		"OPENDOOR":
			actor.open_door()
			run_cut_scene()
		"CLOSEDOOR":
			actor.close_door()
			run_cut_scene()
