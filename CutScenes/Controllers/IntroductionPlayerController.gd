extends "res://CutScenes/Controllers/CutSceneController.gd"

func package_choreography():
	choreography.append([ENTER, Vector2(267, 154)])
	choreography.append([VISIBLE_OFF])
	choreography.append([CUSTOM, "TOGGLE_CAMERA_SMOOTHING", []])
	choreography.append([CUSTOM, "SET_CAMERA", [Vector2(-375, 100)]])
	choreography.append([CUSTOM, "TOGGLE_CAMERA_SMOOTHING", []])
	choreography.append([WAIT, 0.5])
	choreography.append([CUSTOM, "MOVE_CAMERA", [Vector2(-375, 100), Vector2(0, 0), 10]])
	choreography.append([WAIT, 2.5])
	choreography.append([VISIBLE_ON])
	choreography.append([WAIT, 3])
	var monologue = [
		"What just happened?",
		"And where am I? This looks just like the MacHenry Orchard, but...",
		"...",
		"...things look different.",
	]
	choreography.append([DIALOGUE, monologue, WorldStats.player_name])
	choreography.append([WAIT, 1])
	choreography.append([CUSTOM, "HOP_UP", []])
	choreography.append([CUSTOM, "HOP_DOWN", []])
	monologue = [
		"Bzzzt bzzzt bzzzt...",
	]
	choreography.append([DIALOGUE, monologue, "?????"])
	choreography.append([WAIT, 0.5])
	monologue = [
		"..bzzzt bzzzt...",
	]
	choreography.append([DIALOGUE, monologue, "?????"])
	choreography.append([WAIT, 0.5])
	monologue = [
		"Hello there! I'm FABIO, your Fantastic All-Purpose Builder & Installation Omnitool.",
		"It seems as though we have experienced a dimensional shift in the local universal zone.",
		"Unfortunately, it appears that the interdimensional traverse has corrupted my higher level functions.",
		"I am currently limited to survival schematics and sensors. I appologize for any inconvenince.",
		"Thankfully, the brilliant engineers at Fabrio-Tech, Inc. designed me with the ability for self-repair.",
		"My systems are already working on restoring the corrupted files. I will be fully functioning before you know it.",
	]
	choreography.append([DIALOGUE, monologue, "FABIO"])
	choreography.append([WAIT, 1])
	choreography.append([GIVE_QUEST, preload("res://QuestSystem/Quests/MQ_01_0010.tscn"), "FABIO"])
	choreography.append([RELEASE_ACTOR])

func custom_actions(action_name, args):
	match action_name:
		"TOGGLE_PLAYER_VISIBLE":
			actor.visible = !actor.visible
			run_cut_scene()
		"TOGGLE_CAMERA_SMOOTHING":
			var camera = get_node("/root/Game/BillsFarm/Camera2D")
			camera.set_enable_follow_smoothing(!camera.smoothing_enabled)
			run_cut_scene()
		"SET_CAMERA":
			get_node("/root/Game/BillsFarm/YSort/Player/RemoteTransform2D").position = args[0]
			run_cut_scene()
		"MOVE_CAMERA":
			tween.interpolate_property(get_node("/root/Game/BillsFarm/YSort/Player/RemoteTransform2D"), "position", args[0], args[1], args[2], Tween.TRANS_LINEAR, Tween.EASE_IN)
			is_acting = true
			tween.start()
		"HOP_UP":
			tween.interpolate_property(actor.sprite, "position", Vector2(0, -9), Vector2(0, -18), 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
			is_acting = true
			tween.start()
		"HOP_DOWN":
			tween.interpolate_property(actor.sprite, "position", Vector2(0, -18), Vector2(0, -9), 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN)
			is_acting = true
			tween.start()
