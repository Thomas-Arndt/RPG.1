extends "res://CutScenes/Controllers/CutSceneController.gd"

func package_choreography():
	choreography.append([ENTER, get_tree().get_nodes_in_group("Player")[0].global_position])
	choreography.append([WAIT, 0.5])
	var monologue = [
		"Who's there?",
	]
	choreography.append([DIALOGUE, monologue, "Dale"])
	choreography.append([WAIT, 3])
	choreography.append([RELEASE_PLAYER])
	choreography.append([RELEASE_ACTOR])

func custom_actions(action_name, args):
	match action_name:
		"PASS":
			pass
			
