extends "res://CutScenes/Controllers/CutSceneController.gd"

export (Array, String) var monologue
export (String) var speaker

func package_choreography():
	choreography.append([ENTER, get_tree().get_nodes_in_group("Player")[0].global_position])
	choreography.append([CUSTOM, "move_away", []])
	choreography.append([DIALOGUE, monologue, speaker])
	choreography.append([CUSTOM, "deactivate_trigger", []])
	choreography.append([RELEASE_PLAYER])
	choreography.append([RELEASE_ACTOR])
	
func custom_actions(action_name, args):
	var trigger = get_parent().get_parent()
	match action_name:
		"move_away":
			var direction = trigger.trigger_area.global_position.direction_to(actor.global_position)
			actor.global_position += direction*7
			run_cut_scene()
		"deactivate_trigger":
			trigger.active = false
			get_tree().get_nodes_in_group("World")[0].save_scene()
			run_cut_scene()
