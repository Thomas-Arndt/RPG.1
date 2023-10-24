extends Area2D
class_name InteractionZone

signal interaction_started(node)
signal interaction_finished(node)

onready var collision_shape: Node = $CollisionShape2D
onready var Actions: Node = $Actions

func start_interaction(node = null) -> void:
	var active_actions: int = 0
	var has_follow_up: bool = false
	emit_signal("interaction_started", self)
	var actions = Actions.get_children()
	if (len(actions) > 0):
		for action in actions:
			if action.active:
				active_actions += 1
				if not action.is_connected("finished", self, "_on_Action_finished"):
					action.connect("finished", self, "_on_Action_finished")
				action.interact()
	if active_actions == 0:
		emit_signal("interaction_finished", self)

func _on_Action_finished():
	emit_signal("interaction_finished", self)
