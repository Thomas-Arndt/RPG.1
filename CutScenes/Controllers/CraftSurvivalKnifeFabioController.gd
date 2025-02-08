extends "res://CutScenes/Controllers/CutSceneController.gd"

var player_position: Vector2

func package_choreography():
	choreography.append([PAUSE_FOR_DIALOGUE, []])
	choreography.append([WAIT, 0.4])
	choreography.append([ENTER, get_tree().get_nodes_in_group("Player")[0].global_position+(Vector2(22, 12))])
	choreography.append([PAUSE_FOR_DIALOGUE, []])
	choreography.append([WAIT, 0.3])	
	choreography.append([EXIT])

func custom_actions(action_name, args):
	match action_name:
		"PASS":
			pass
