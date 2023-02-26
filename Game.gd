extends Node

var pause_signals = false

func _ready():
	PlayerStats.set_experience(0)
	PlayerStats.set_player_level(1)
	Inventory.set_gold(0)
	Inventory.set_max_gold(1000)
	get_tree().get_nodes_in_group("Player")[0].global_position = WorldStats.player_spawn_vector
	QuestSystem.load_quest_progress()
	get_tree().get_nodes_in_group("World")[0].load_scene()
	SignalBus.connect("scene_link_entered", self, "_on_Scene_Link_entered")

	
func _on_Scene_Link_entered(destination_reference):
	if ResourceLoader.exists(destination_reference):
		get_tree().get_nodes_in_group("Player")[0].paused(true)
		TransitionLayer.scene_out()
		yield(TransitionLayer, "finished")
		var origin = get_tree().get_nodes_in_group("World")[0]
		origin.save_scene()
		remove_child(origin)
		origin.queue_free()
		var destination = ResourceLoader.load(destination_reference).instance()
		add_child(destination)
		get_tree().get_nodes_in_group("Player")[0].paused(true)
		destination.load_scene()
		var player = get_tree().get_nodes_in_group("Player")[0]
		player.spawn_player()
		yield(get_tree().create_timer(0.5), "timeout")
		TransitionLayer.scene_in()
		yield(TransitionLayer, "finished")
		get_tree().get_nodes_in_group("Player")[0].paused(false)

