extends "res://CutScenes/Controllers/CutSceneController.gd"

func package_choreography():
	choreography.append([ENTER, get_tree().get_nodes_in_group("Player")[0].global_position])
	choreography.append([CUSTOM, "CLOSE_BACKPACK", []])
	choreography.append([WAIT, 0.5])
	var monologue = [
		"Bzzzt bzzzt bzzzt...",
	]
	choreography.append([DIALOGUE, monologue, "Fabio"])
	choreography.append([WAIT, 0.7])
	monologue = [
		"Excellent, you can now dig to your heart's content!",
		"We should probably go check in with Loni to see if he has any guidance.",
	]
	choreography.append([DIALOGUE, monologue, "Fabio"])
	#choreography.append([GIVE_QUEST, preload("res://QuestSystem/Quests/MQ_01_0080.tscn"), ""])
	choreography.append([RELEASE_PLAYER])
	choreography.append([RELEASE_ACTOR])
	
func custom_actions(action_name, args):
	match action_name:
		"CLOSE_BACKPACK":
			UI.Backpack.toggle_backpack()
			if UI.Backpack.state:
				actor.is_running = false
			else:
				actor.is_running = true
			run_cut_scene()
