extends Area2D
class_name InteractionZone

signal interaction_started
signal interaction_finished(node)

onready var Actions: Node = $Actions

func start_interaction(node) -> void:
	emit_signal("interaction_started", node)
	var actions = Actions.get_children()
	if (len(actions) > 0):
		for action in actions:
			if action.active:
				action.interact()
				yield(action, "finished")
	emit_signal("interaction_finished", self)
	
