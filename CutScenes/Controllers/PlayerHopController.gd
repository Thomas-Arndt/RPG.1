extends "res://CutScenes/Controllers/CutSceneController.gd"

func package_choreography():
	choreography.append([CUSTOM, "ENTER", []])
	choreography.append([EMOTE, "exclamation", "show"])
	choreography.append([CUSTOM, "HOP_UP", []])
	choreography.append([CUSTOM, "HOP_DOWN", []])
	choreography.append([EMOTE, "exclamation", "hide"])
	choreography.append([WAIT, 0.15])
	choreography.append([RELEASE_ACTOR])
	choreography.append([RELEASE_PLAYER])
	
func custom_actions(action_name, args):
	match action_name:
		"ENTER":
			actor = get_tree().get_nodes_in_group("Player")[0]
			actor.state_machine_pause()
			toggle_visible_on()
			run_cut_scene()
		"HOP_UP":
			tween.interpolate_property(actor.sprite, "position", Vector2(0, -9), Vector2(0, -20), 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
			is_acting = true
			tween.start()
		"HOP_DOWN":
			tween.interpolate_property(actor.sprite, "position", Vector2(0, -20), Vector2(0, -9), 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN)
			is_acting = true
			tween.start()
		
