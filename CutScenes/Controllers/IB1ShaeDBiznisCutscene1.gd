extends "res://CutScenes/Controllers/CutSceneController.gd"

func package_choreography():
	choreography.append([ENTER, Vector2(65, 160)])
	choreography.append([WAIT, 2.5])
	choreography.append([CUSTOM, "HOP_UP", []])
	choreography.append([CUSTOM, "HOP_DOWN", []])
	choreography.append([WAIT, 0.75])
	var monologue = [
		"Oh my, oh me, what's this I see?",
		"Someone has followed most tenaciously.",
		"I'll run away and sweep my tracks,",
		"That should keep them off my backs."
	]
	choreography.append([DIALOGUE, monologue, ""])
	choreography.append([WAIT, 0.75])
	choreography.append([MOVE_TO, Vector2(30, 191), 0.5, "walk_left"])
	choreography.append([EXIT])
	
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
