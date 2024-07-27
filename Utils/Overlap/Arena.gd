extends Area2D

var combatants: Array = [];

func is_in_arena(body):
	var result = false
	for combatant in combatants:
		if combatant == body:
			result = true
	return result

func _on_Arena_body_entered(body):
	combatants.append(body)
	if body.has_method("entered_arena"):
		body.entered_arena()

func _on_Arena_body_exited(body):
	var temp_array = []
	for combatant in combatants:
		if combatant != body:
			temp_array.append(combatant)
		else:
			if body.has_method("exited_arena"):
				body.exited_arena()
	combatants = temp_array
