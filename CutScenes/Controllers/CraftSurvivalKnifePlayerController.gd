extends "res://CutScenes/Controllers/CutSceneController.gd"

func package_choreography():
	choreography.append([ENTER, get_tree().get_nodes_in_group("Player")[0].global_position])
	choreography.append([WAIT, 0.5])
	var monologue = [
		"Bzzzt bzzzt bzzzt...",
	]
	choreography.append([DIALOGUE, monologue, "Fabio"])
	choreography.append([WAIT, 0.7])
	monologue = [
		"Hey there! It appears that you have found the appropriate materials for me to create a super handy Survival Knife!",
		"Just one of the many ways the thoughtful engineers at Fabrio-Tech, Inc have your safety in mind.",
		"Simply open up the crafting menu by pressing F, select the Survival Knife recipe, and I will take care of the rest.",
	]
	choreography.append([DIALOGUE, monologue, "Fabio"])
	choreography.append([WAIT, 0.5])
	choreography.append([RELEASE_PLAYER])
	choreography.append([RELEASE_ACTOR])
	
func custom_actions(action_name, args):
	match action_name:
		"PASS":
			pass
