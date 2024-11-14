extends "res://CutScenes/Controllers/CutSceneController.gd"

func package_choreography():
	choreography.append([CUSTOM, "FLIP_SWITCH", ["2", "open"]])	
	choreography.append([ENTER, Vector2(-48, -20)])
	choreography.append([WAIT, 1])
	choreography.append([CUSTOM, "FLIP_SWITCH", ["1", "open"]])	
	choreography.append([WAIT, 0.75])
	var monologue = [
		"Open a door, what's inside?"
	]
	choreography.append([DIALOGUE, monologue, ""])
	choreography.append([WAIT, 0.75])
	choreography.append([MOVE_TO, Vector2(48, -20), 1.25, "walk_right"])
	choreography.append([MOVE_TO, Vector2(48, -20), 0.01, "idle_down"])
	choreography.append([WAIT, 0.25])
	choreography.append([CUSTOM, "FLIP_SWITCH", ["2", "close"]])	
	choreography.append([WAIT, 0.75])
	monologue = [
		"Close a door, nothing to hide.",
	]
	choreography.append([DIALOGUE, monologue, ""])
	choreography.append([WAIT, 0.75])
	choreography.append([CUSTOM, "SHAKE", []])
	choreography.append([WAIT, 1.5])
	choreography.append([CUSTOM, "STOP_SHAKE", []])
	monologue = [
		"What is that I hear? Something large I fear!",
	]
	choreography.append([DIALOGUE, monologue, ""])
	choreography.append([WAIT, 2])
	
	monologue = [
		"Time for me to go. Please enjoy the show!",
	]
	choreography.append([DIALOGUE, monologue, ""])
	choreography.append([MOVE_TO, Vector2(0, -85), 1, "walk_left"])
	choreography.append([EXIT])
	choreography.append([CUSTOM, "FLIP_SWITCH", ["1", "close"]])	
	
func custom_actions(action_name, args):
	match action_name:
		"FLIP_SWITCH":
			SignalBus.emit_signal("event_switch", args[0], args[1])
			run_cut_scene()	
		"SHAKE":
			SignalBus.emit_signal("screen_shake", -1, 15, 5, 0)
			run_cut_scene()
		"STOP_SHAKE":
			SignalBus.emit_signal("stop_camera_effect", "screen_shake")
			run_cut_scene()	
