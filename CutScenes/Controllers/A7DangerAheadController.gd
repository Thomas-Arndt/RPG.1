extends "res://CutScenes/Controllers/CutSceneController.gd"

func package_choreography():
	choreography.append([ENTER, get_tree().get_nodes_in_group("Player")[0].global_position])
	choreography.append([WAIT, 0.5])
	var monologue = [
		"*** PROXIMITY ALERT ***",
		"My emergency sensors detect an increased number of hostile entities in your vicinity.",
		"Proceed with caution, and a full supply of handy items thoughtfully designed by the excellent engineers at at FabrioTech, Inc."
	]
	choreography.append([DIALOGUE, monologue, "Fabio"])
	choreography.append([RELEASE_PLAYER])
	choreography.append([RELEASE_ACTOR])
