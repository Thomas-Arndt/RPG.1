extends Node

export var default_scene : String = "res://World/Areas/BillsFarm.tscn"

var pause_signals = false

func _ready():
	Inventory.set_gold(0)
	Inventory.set_max_gold(1000)
	
	Inventory.load_inventory()
	WorldStats.load_stats()
	QuestSystem.load_quest_progress()
	
	if ResourceLoader.exists(WorldStats.last_loaded_scene):
		yield(mount_scene(WorldStats.last_loaded_scene, false), "completed")
	else:
		yield(mount_scene(default_scene, false), "completed")
	
	#get_tree().get_nodes_in_group("Player")[0].spawn_player()
	get_tree().get_nodes_in_group("Player")[0].global_position = Vector2.ZERO
	PlayerStats.load_stats()
	
	SignalBus.connect("scene_link_entered", self, "_on_Scene_Link_entered")

	
func _on_Scene_Link_entered(destination_reference):
	if ResourceLoader.exists(destination_reference):
		yield(unmount_scene(), "completed")
		yield(mount_scene(destination_reference), "completed")

func unmount_scene(transition : bool = true):
	get_tree().get_nodes_in_group("Player")[0].paused(true)
	PlayerStats.save_stats()
	if transition:
		TransitionLayer.scene_out()
		yield(TransitionLayer, "finished")
	var origin = get_tree().get_nodes_in_group("World")[0]
	origin.save_scene()
	Inventory.save_inventory()
	remove_child(origin)
	origin.queue_free()
	yield(get_tree(), "idle_frame")

func mount_scene(destination_reference, transition : bool = true):
	var destination = ResourceLoader.load(destination_reference).instance()
	WorldStats.set_last_loaded_scene(destination_reference)
	WorldStats.save_stats()
	add_child(destination)
	get_tree().get_nodes_in_group("Player")[0].paused(true)
	destination.load_scene()
	var player = get_tree().get_nodes_in_group("Player")[0]
	player.spawn_player()
	if transition:
		yield(get_tree().create_timer(0.5), "timeout")
		TransitionLayer.scene_in()
		yield(TransitionLayer, "finished")
	get_tree().get_nodes_in_group("Player")[0].paused(false)
	yield(get_tree(), "idle_frame")
