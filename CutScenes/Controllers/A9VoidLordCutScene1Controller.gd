extends "res://CutScenes/Controllers/CutSceneController.gd"

func package_choreography():
	choreography.append([WAIT, 4])
	choreography.append([ENTER, Vector2(561, -595)])
	choreography.append([WAIT, 1])
	choreography.append([CUSTOM, "HOP_UP", []])
	choreography.append([CUSTOM, "HOP_DOWN", []])
	choreography.append([WAIT, 0.75])
	var monologue = [
		"**Gasp!** It's worse here than I thought!!",
	]
	choreography.append([DIALOGUE, monologue, ""])
	choreography.append([MOVE_TO, Vector2(503, -598), 0.5, "walk"])
	choreography.append([CUSTOM, "EXPLODE", []])
	choreography.append([WAIT, 0.25])
	choreography.append([CUSTOM, "FLIP_SPRITE", []])
	choreography.append([WAIT, 0.25])
	monologue = [
		"You there! You shouldn't be here!",
	]
	choreography.append([DIALOGUE, monologue, ""])
	choreography.append([WAIT, 0.75])
	choreography.append([MOVE_TO, Vector2(619, -598), 0.8, "walk"])
	choreography.append([CUSTOM, "EXPLODE", []])
	monologue = [
		"This is bad...",
		"EEK! And even worse, I've been spotted! Don't mind me. I'm just a figment of your imagination."
	]
	choreography.append([DIALOGUE, monologue, ""])
	choreography.append([WAIT, 1.75])
	choreography.append([MOVE_TO, Vector2(561, -595), 0.5, "walk"])
	choreography.append([EXIT])
	
func custom_actions(action_name, args):
	match action_name:
		"HOP_UP":
			tween.interpolate_property(actor.green_sprite_full, "position", Vector2(0, -46), Vector2(0, -57), 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
			is_acting = true
			tween.start()
		"HOP_DOWN":
			tween.interpolate_property(actor.green_sprite_full, "position", Vector2(0, -57), Vector2(0, -46), 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT)
			is_acting = true
			tween.start()
		"EXPLODE":
			actor.anim_player.play("explode")
			yield(actor.anim_player, "animation_finished")
			actor.anim_player.play("exploding")
			yield(actor.anim_player, "animation_finished")
			actor.anim_player.play("implode")
			yield(actor.anim_player, "animation_finished")
			run_cut_scene()
		"FLIP_SPRITE":
			actor.flip_sprite(1)
			run_cut_scene()
