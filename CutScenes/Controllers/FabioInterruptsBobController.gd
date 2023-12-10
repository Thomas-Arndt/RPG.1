extends "res://CutScenes/Controllers/CutSceneController.gd"


func package_choreography():
	choreography.append([ENTER, get_tree().get_nodes_in_group("Player")[0].global_position])
	choreography.append([WAIT, 1.5])
	var monologue = [
		"Bzzzt bzzzt bzzzt...",
	]
	choreography.append([DIALOGUE, monologue, "Fabio"])
	choreography.append([WAIT, 0.7])
	monologue = [
		"Hey there! I couldn't help but hear that you require a hand-held excavation device.",
		"As it just so happens, my self-repair systems have just restored the schematics for an iron pickaxe.",
		"That is just one of the many useful tools that are awaiting recovery from my databanks.",
		"If you can locate two iron bars and some wood, I can fabricate you one in a jiffy.",
	]
	choreography.append([DIALOGUE, monologue, "Fabio"])
	choreography.append([CUSTOM, "continue_quest_line", []])
	choreography.append([RELEASE_PLAYER])
	choreography.append([RELEASE_ACTOR])
	
func custom_actions(action_name, args):
	match action_name:
		"continue_quest_line":
			SignalBus.emit_signal("modify_node_property", "after-fabio-interrupts-bob")
			run_cut_scene()
