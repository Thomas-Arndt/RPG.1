extends Node

export var default_scene : String = "res://UI/Backgrounds/ScrollingStarfield.tscn"

func _ready():
	var destination = ResourceLoader.load(default_scene).instance()
	add_child(destination)
	UI.set_state(UI.states.MAIN)
	SignalBus.connect("scene_link_entered", self, "_on_Scene_Link_entered")

func _on_Scene_Link_entered(destination_reference):
	if ResourceLoader.exists(destination_reference):
		yield(unmount_scene(), "completed")
		yield(mount_scene(destination_reference), "completed")

func unmount_scene(transition : bool = true):
	var player = get_tree().get_nodes_in_group("Player")
	if len(player) > 0:
		player[0].paused(true)
	PlayerStats.save_stats()
	if transition:
		TransitionLayer.scene_out()
		yield(TransitionLayer, "finished")
	var menu = get_tree().get_nodes_in_group("Menu")
	if len(menu) > 0:
		remove_child(menu[0])
	var origin = get_tree().get_nodes_in_group("World")
	if len(origin) > 0:
		origin[0].save_scene()
		Inventory.save_inventory()
		remove_child(origin[0])
		origin[0].queue_free()
	yield(get_tree(), "idle_frame")

func mount_scene(destination_reference, transition : bool = true):
	var destination = ResourceLoader.load(destination_reference).instance()
	WorldStats.set_last_loaded_scene(destination_reference)
	WorldStats.save_stats()
	add_child(destination)
	var player = get_tree().get_nodes_in_group("Player")
	if len(player) > 0:
		player[0].paused(true)
	destination.load_scene()
	if destination is WorldScene:
		UI.set_state(UI.states.OVERWORLD)
	elif destination is CutScene:
		UI.set_state(UI.states.CUTSCENE)
	player = get_tree().get_nodes_in_group("Player")
	if len(player) > 0:
		player[0].spawn_player()
	if transition:
		yield(get_tree().create_timer(0.5), "timeout")
		TransitionLayer.scene_in()
		yield(TransitionLayer, "finished")
	if len(player) > 0:
		player[0].paused(false)
	yield(get_tree(), "idle_frame")
