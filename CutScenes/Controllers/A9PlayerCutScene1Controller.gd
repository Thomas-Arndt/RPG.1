extends "res://CutScenes/Controllers/CutSceneController.gd"

var displacement : Vector2

func package_choreography():
	choreography.append([ENTER, get_tree().get_nodes_in_group("Player")[0].global_position])
	choreography.append([WAIT, 0.75])
	choreography.append([CUSTOM, "HOP_UP", []])
	choreography.append([CUSTOM, "HOP_DOWN", []])
	choreography.append([CUSTOM, "SET_DISPLACEMENT", []])
	choreography.append([CUSTOM, "MOVE_CAMERA", [0.2]])
	choreography.append([PAUSE_FOR_DIALOGUE, []])
	choreography.append([PAUSE_FOR_DIALOGUE, []])
	choreography.append([PAUSE_FOR_DIALOGUE, []])
	choreography.append([WAIT, 5.5])
	choreography.append([CUSTOM, "REVERT_DISPLACEMENT", []])
	choreography.append([CUSTOM, "MOVE_CAMERA", [0.2]])
	choreography.append([WAIT, 0.75])
	choreography.append([RELEASE_ACTOR])
	choreography.append([RELEASE_PLAYER])
func custom_actions(action_name, args):
	match action_name:
		"SET_DISPLACEMENT":
			displacement = (get_node("/root/Game/A9/YSort/NPCs/VoidLordPosition").global_position - (actor.global_position)) *.75
			run_cut_scene()
		"REVERT_DISPLACEMENT":
			displacement = -displacement
			run_cut_scene()
		"MOVE_CAMERA":
			var remote_transform : RemoteTransform2D = get_node("/root/Game/A9/YSort/Player/RemoteTransform2D")
			tween.interpolate_property(remote_transform, "position", remote_transform.position, remote_transform.position + displacement, args[0], Tween.TRANS_LINEAR, Tween.EASE_IN)
			is_acting = true
			tween.start()
		"HOP_UP":
			tween.interpolate_property(actor.sprite, "position", Vector2(0, -9), Vector2(0, -20), 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
			is_acting = true
			tween.start()
		"HOP_DOWN":
			tween.interpolate_property(actor.sprite, "position", Vector2(0, -20), Vector2(0, -9), 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN)
			is_acting = true
			tween.start()
