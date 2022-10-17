extends "res://Utils/Controllers/CutSceneController.gd"


func package_choreography():
	choreography.append([WAIT, 3])
	choreography.append([ENTER, Vector2.ZERO])
	choreography.append([CUSTOM, "monitorable_off", []])
	choreography.append([WAIT, 1.5])
	choreography.append([MOVE_TO, Vector2(-80, 680), 1, "walk"])
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
	choreography.append([MOVE_TO, Vector2(-25,620), 0.5, "walk"])
	choreography.append([CUSTOM, "look_right", []])
	choreography.append([WAIT, .75])
	choreography.append([CUSTOM, "look_left", []])
	choreography.append([WAIT, 0.75])
	choreography.append([CUSTOM, "look_right", []])
	choreography.append([WAIT, 1])
	choreography.append([MOVE_TO, Vector2(-25,740), 0.8, "walk"])
	choreography.append([WAIT, .75])
	choreography.append([CUSTOM, "look_left", []])
	choreography.append([WAIT, 0.75])
	choreography.append([CUSTOM, "look_right", []])
	choreography.append([WAIT, 1])
	choreography.append([MOVE_TO, Vector2(-25,680), 0.5, "walk"])
	choreography.append([WAIT, 0.35])
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
			
