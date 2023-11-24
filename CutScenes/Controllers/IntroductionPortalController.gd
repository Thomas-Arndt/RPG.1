extends "res://CutScenes/Controllers/CutSceneController.gd"


func package_choreography():
	choreography.append([ENTER, Vector2(267, 145)])
	choreography.append([CUSTOM, "initialize", []])
	choreography.append([WAIT, 11])
	choreography.append([CUSTOM, "open_and_hold", []])
	choreography.append([WAIT, 2.7])
	choreography.append([CUSTOM, "close", []])
	choreography.append([WAIT, 1])
	choreography.append([EXIT])
	choreography.append([DELETE_ACTOR])


func custom_actions(action_name, args):
	match action_name:
		"open_and_hold":
			toggle_visible_on()
			actor.open_and_hold()
			run_cut_scene()
		"close":
			actor.close()
			run_cut_scene()
		"initialize":
			actor.get_parent().move_child(actor, 0)
			actor.match_dimension(WorldStats.DIMENSION)
			actor.anim_player.play("RESET")
			toggle_visible_off()
			run_cut_scene()
