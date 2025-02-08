extends "res://CutScenes/Controllers/CutSceneController.gd"

func package_choreography():
	choreography.append([PAUSE_FOR_DIALOGUE, []])
	choreography.append([PAUSE_FOR_DIALOGUE, []])
	choreography.append([PAUSE_FOR_DIALOGUE, []])
	choreography.append([WAIT, 0.5])
	choreography.append([ENTER, get_tree().get_nodes_in_group("Player")[0].global_position+(Vector2(22, 12))])
	choreography.append([PAUSE_FOR_DIALOGUE, []])
	choreography.append([WAIT, 1])	
	choreography.append([CUSTOM, "HOP_UP", []])
	choreography.append([CUSTOM, "HOP_DOWN", []])
	choreography.append([PAUSE_FOR_DIALOGUE, []])
	choreography.append([EXIT])

func custom_actions(action_name, args):
	match action_name:
		"HOP_UP":
			tween.interpolate_property(actor.sprite, "position", Vector2(0, -9), Vector2(0, -15), 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
			is_acting = true
			tween.start()
		"HOP_DOWN":
			tween.interpolate_property(actor.sprite, "position", Vector2(0, -15), Vector2(0, -9), 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN)
			is_acting = true
			tween.start()
