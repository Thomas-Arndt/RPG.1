extends "res://CutScenes/Controllers/CutSceneController.gd"

func package_choreography():
	choreography.append([PAUSE_FOR_DIALOGUE, []])
	choreography.append([PAUSE_FOR_DIALOGUE, []])
	choreography.append([PAUSE_FOR_DIALOGUE, []])
	choreography.append([WAIT, 0.5])
	choreography.append([ENTER, Vector2(0, -85)])
	choreography.append([PAUSE_FOR_DIALOGUE, []])
	choreography.append([WAIT, 2])
	choreography.append([CUSTOM, "CLOSE_PORTAL", []])
	choreography.append([WAIT, 2])
	choreography.append([EXIT])

func custom_actions(action_name, args):
	match action_name:
		"CLOSE_PORTAL":
			actor.close()
			run_cut_scene()
		"OPEN_PORTAL":
			actor.open_and_hold();
			run_cut_scene()
			
