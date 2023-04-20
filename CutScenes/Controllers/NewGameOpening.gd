extends "res://CutScenes/Controllers/CutSceneController.gd"


func package_choreography():
	choreography.append([WAIT, 1])
	var monologue = [
		"..."
	]
	choreography.append([DIALOGUE, monologue, WorldStats.player_name])
	choreography.append([ENTER, Vector2(160, 70)])
	choreography.append([WAIT, 1])
	monologue = [
		"...",
		"Where am I?",
		"...",
		"Weird! At first I wasn't, and then I was!",
	]
	choreography.append([DIALOGUE, monologue, WorldStats.player_name])
	choreography.append([EXIT])
	monologue = [
		"Oh dip! I'm not again...",
		"...",
	]
	choreography.append([DIALOGUE, monologue, WorldStats.player_name])
	choreography.append([CUSTOM, "change_scene", []])

func custom_actions(action_name, args):
	match action_name:
		"change_scene":
			SignalBus.emit_signal("scene_link_entered", "res://World/Areas/BillsFarm.tscn")
			run_cut_scene()
