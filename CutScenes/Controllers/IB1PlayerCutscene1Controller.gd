extends "res://CutScenes/Controllers/CutSceneController.gd"

func package_choreography():
	choreography.append([ENTER, get_tree().get_nodes_in_group("Player")[0].global_position])
	choreography.append([WAIT, 1.2])
	choreography.append([EMOTE, "exclamation", "show"])
	choreography.append([WAIT, 0.5])
	choreography.append([MOVE_CAMERA, Vector2(65, 160), "IB1", 0.2])
	choreography.append([WAIT, 1])
	choreography.append([EMOTE, "exclamation", "hide"])
	choreography.append([PAUSE_FOR_DIALOGUE, []])	
	choreography.append([WAIT, 2.25])
	choreography.append([RETURN_CAMERA, "IB1", 0.2])
	choreography.append([WAIT, 0.75])
	var monologue = [
		"Hey there! Isn't this an odd place?",
		"None of my Fabrio-Tech-designed sensors seem to be able to calculate a point of reference for our current location.",
		"I will of course log this anomaly for the brilliant engineers and Fabrio-Tech, Inc to solve.",
		"My sensors do seem to note some striking similarities between this place and our earlier interdimensional traverse.",
		"This time things seem to be more stable, however, as I do not appear to be having any memory corruption issues like before.",
		"I would recommend caution and to leave this place as soon as you can."
	]
	choreography.append([DIALOGUE, monologue, "Fabio"])
	choreography.append([RELEASE_ACTOR])
	choreography.append([RELEASE_PLAYER])
	
func custom_actions(action_name, args):
	match action_name:
		"":
			pass
		
