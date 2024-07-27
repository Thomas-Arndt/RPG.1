extends "res://CutScenes/Controllers/CutSceneController.gd"

var displacement : Vector2

func package_choreography():
	choreography.append([ENTER, get_tree().get_nodes_in_group("Player")[0].global_position])
	choreography.append([WAIT, 0.75])
	choreography.append([CUSTOM, "SHAKE", []])
	choreography.append([CUSTOM, "HOP_UP", []])
	choreography.append([CUSTOM, "HOP_DOWN", []])
	choreography.append([WAIT, 1.5])
	choreography.append([CUSTOM, "STOP_SHAKE", []])
	choreography.append([CUSTOM, "RELEASE_SERPENT", []])
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
		"RELEASE_SERPENT":
			var head = get_tree().get_nodes_in_group("SerpentHead")[0]
			head.state = head.states.STAMPEDE
			run_cut_scene()
		"SHAKE":
			SignalBus.emit_signal("screen_shake", -1, 15, 5, 0)
			run_cut_scene()
		"STOP_SHAKE":
			SignalBus.emit_signal("stop_camera_effect", "screen_shake")
			run_cut_scene()
