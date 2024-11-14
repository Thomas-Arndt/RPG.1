extends "res://CutScenes/Controllers/CutSceneController.gd"

func package_choreography():
	choreography.append([ENTER, get_tree().get_nodes_in_group("Player")[0].global_position])
	choreography.append([EMOTE, "exclamation", "show"])
	choreography.append([WAIT, 0.5])
	choreography.append([MOVE_CAMERA, Vector2(0, -130), "BPC1c", 0.2])
	choreography.append([WAIT, 1])
	choreography.append([EMOTE, "exclamation", "hide"])
	choreography.append([PAUSE_FOR_DIALOGUE, []])
	choreography.append([PAUSE_FOR_DIALOGUE, []])
	choreography.append([PAUSE_FOR_DIALOGUE, []])
	choreography.append([PAUSE_FOR_DIALOGUE, []])	
	choreography.append([WAIT, 3.5])
	choreography.append([RETURN_CAMERA, "BPC1c", 0.2])
	choreography.append([WAIT, 0.75])
	choreography.append([RELEASE_ACTOR])
	choreography.append([RELEASE_PLAYER])
	
func custom_actions(action_name, args):
	match action_name:
		"HOP_UP":
			tween.interpolate_property(actor.sprite, "position", Vector2(0, -9), Vector2(0, -20), 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
			is_acting = true
			tween.start()
		"HOP_DOWN":
			tween.interpolate_property(actor.sprite, "position", Vector2(0, -20), Vector2(0, -9), 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN)
			is_acting = true
			tween.start()
		
