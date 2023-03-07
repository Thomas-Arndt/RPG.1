extends "res://Utils/Controllers/CutSceneController.gd"


func package_choreography():
	choreography.append([WAIT, 3])
	choreography.append([ENTER, Vector2(80, 670)])
	choreography.append([CUSTOM, "initialize", []])
	choreography.append([CUSTOM, "monitorable_off", []])
	#choreography.append([WAIT, 1.5])

	choreography.append([SEEK_PLAYER, Vector2(80, 670), 100, 1, "walk"])
	var monologue = [
		"Hello!"
	]
	choreography.append([DIALOGUE, monologue, ""])
	monologue = [
		"I am Blib.",
		"Do NOT be alarmed.",
		"IGNORE ME!"
	]
	choreography.append([DIALOGUE, monologue, "Blib"])
	choreography.append([WAIT, 1])
#	choreography.append([MOVE_TO, Vector2(-25,620), 0.5, "walk"])
#	choreography.append([CUSTOM, "look_right", []])
#	choreography.append([WAIT, .75])
#	choreography.append([CUSTOM, "look_left", []])
#	choreography.append([WAIT, 0.75])
#	choreography.append([CUSTOM, "look_right", []])
#	choreography.append([WAIT, 1])
#	choreography.append([MOVE_TO, Vector2(-25,740), 0.8, "walk"])
#	choreography.append([WAIT, .75])
#	choreography.append([CUSTOM, "look_left", []])
#	choreography.append([WAIT, 0.75])
#	choreography.append([CUSTOM, "look_right", []])
#	choreography.append([WAIT, 1])
#	choreography.append([MOVE_TO, Vector2(-25,680), 0.5, "walk"])
#	choreography.append([WAIT, 0.35])
	monologue = [
		"All of this energy!"
	]
	choreography.append([DIALOGUE, monologue, "Blib"])
	choreography.append([WAIT, .75])
	choreography.append([CUSTOM, "look_left", []])
	choreography.append([WAIT, 0.75])
	choreography.append([CUSTOM, "look_right", []])
	choreography.append([WAIT, 0.35])
	monologue = [
		"I mUsT hAvE iT!!!"
	]
	choreography.append([DIALOGUE, monologue, "Blib"])
	choreography.append([CUSTOM, "set_detection_zones", []])
	choreography.append([RELEASE_PLAYER])
	choreography.append([CUSTOM, "monitorable_on", []])
	choreography.append([RELEASE_ACTOR])
	

func custom_actions(action_name, args):
	match action_name:
		"monitorable_on":
			actor.wander_controller.monitorable_on()
			run_cut_scene()
		"monitorable_off":
			actor.wander_controller.monitorable_off()
			run_cut_scene()
		"look_left":
			actor.flip_sprite(-1)
			run_cut_scene()
		"look_right":
			actor.flip_sprite(1)
			run_cut_scene()
		"initialize":
			actor.is_red = false
			actor.spawn_with_cutscene = true
			actor.match_dimension(WorldStats.DIMENSION)
			run_cut_scene()
		"set_detection_zones":
			actor.wander_controller.add_detection_zone(Vector2(-150, -86))
			actor.wander_controller.add_detection_zone(Vector2(0, -86))
			actor.wander_controller.add_detection_zone(Vector2(150, -86))
			actor.wander_controller.add_detection_zone(Vector2(-150, 72))
			actor.wander_controller.add_detection_zone(Vector2(0, 72))
			actor.wander_controller.add_detection_zone(Vector2(150, 72))
			actor.wander_controller.update_target_position()
			run_cut_scene()
			
