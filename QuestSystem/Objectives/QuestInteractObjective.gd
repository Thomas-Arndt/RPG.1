extends QuestObjective
class_name QuestInteractObjective

export var interact_with: PackedScene

func _ready() -> void:
	for interaction_zone in get_tree().get_nodes_in_group("Interaction Zones"):
		interaction_zone.connect("interaction_finished", self, "_on_Interaction_Zone_interaction_finished")

func _on_Interaction_Zone_interaction_finished(node) -> void:
	if node.filename == interact_with.resource_path and not completed:
		finish()

func as_text() -> String:
	return "Speak with %s %s" % [interact_with.instance().name, "(completed)" if completed else ""]
	
