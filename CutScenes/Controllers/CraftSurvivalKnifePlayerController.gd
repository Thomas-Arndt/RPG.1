extends "res://CutScenes/Controllers/CutSceneController.gd"

func package_choreography():
	choreography.append([DELIVER_QUEST, preload("res://QuestSystem/Quests/MQ_01_0010.tscn"), ""])
	choreography.append([ENTER, get_tree().get_nodes_in_group("Player")[0].global_position])
	choreography.append([WAIT, 0.5])
	var monologue = [
		"Bzzzt bzzzt bzzzt...",
	]
	choreography.append([DIALOGUE, monologue, "Fabio"])
	choreography.append([WAIT, 0.7])
	monologue = [
		"Alright! I see you have enough materials. Let's get cookin'!",
		"Open the Fabrication Menu by pressing <F> and select the Survival Knife from the options.",
		"My energy reserves are low, but I should have plenty for this.",
	]
	choreography.append([DIALOGUE, monologue, "Fabio"])
	choreography.append([RELEASE_PLAYER])
	choreography.append([RELEASE_ACTOR])
	
func custom_actions(action_name, args):
	match action_name:
		"PASS":
			pass
