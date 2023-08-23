extends "res://CutScenes/Controllers/CutSceneController.gd"


func package_choreography():
	choreography.append([CUSTOM, "fade_in", []])
	choreography.append([WAIT, 1])
	var monologue = [
		"..."
	]
	choreography.append([DIALOGUE, monologue, WorldStats.player_name])
	choreography.append([ENTER, Vector2(-20, 0)])
	choreography.append([MOVE_TO, Vector2(160, 80), 5, "spin_down"])
	choreography.append([WAIT, 1])
	monologue = [
		"...",
		"Where am I?",
		"...",
		"Weird! At first I wasn't, and then I was!",
	]
	choreography.append([DIALOGUE, monologue, WorldStats.player_name])
	choreography.append([WAIT, 1.5])
	choreography.append([CUSTOM, "shake", []])
	monologue = [
		"...",
		"Something's happening...",
	]
	choreography.append([DIALOGUE, monologue, WorldStats.player_name])
	choreography.append([WAIT, 0.75])
	choreography.append([CUSTOM, "disappear", []])
	choreography.append([EXIT])
	choreography.append([CUSTOM, "stop_shake", []])
	choreography.append([WAIT, 0.75])
	monologue = [
		"Oh dip! I'm not again...",
		"...",
	]
	choreography.append([DIALOGUE, monologue, WorldStats.player_name])
	choreography.append([CUSTOM, "change_scene", []])

func custom_actions(action_name, args):
	match action_name:
		"change_scene":
			SignalBus.emit_signal("scene_link_entered", "res://World/Above/BillsFarm.tscn")
			run_cut_scene()
		"disappear":
			is_acting = true
			tween.interpolate_property(actor, "modulate:a", 1, 0, 2.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
			tween.start()
		"shake":
			SignalBus.emit_signal("screen_shake", -1, 15, 5, 0)
			run_cut_scene()
		"stop_shake":
			SignalBus.emit_signal("stop_camera_effect", "screen_shake")
			run_cut_scene()
		"fade_in":
			is_acting = true
			var mask = get_tree().get_nodes_in_group("Mask")[0]
			mask.visible = true
			tween.interpolate_property(mask, "modulate:a", 1, 0, 10, Tween.TRANS_QUART, Tween.EASE_IN)
			tween.start()
