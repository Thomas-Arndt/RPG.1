extends Node

onready var world = $World
onready var ySort = $World/YSort
onready var player = $World/YSort/Player

var pause_signals = false

func _ready():
	PlayerStats.set_max_health(10)
	PlayerStats.set_health(10)
	PlayerStats.set_experience(0)
	PlayerStats.set_player_level(1)
	Inventory.set_gold(0)
	Inventory.set_max_gold(100)
	player.global_position = WorldStats.player_spawn_vector
	SignalBus.connect("scene_link_entered", self, "_on_Scene_Link_entered")
	SignalBus.connect("scene_exited", self, "_on_Scene_exited")
	WorldStats.add_room_to_stack(world)
	connect_camera_remote_transform(world)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		player.spawn_player()
	
func _on_Scene_Link_entered(destination_reference, source):
	if not pause_signals:
		pause_signals = true
		var origin_scene = WorldStats.peek_top_of_room_stack()
		remove_child(origin_scene)
		var destination = destination_reference.instance()
		add_child(destination)
		move_child(destination, 0)
		if WorldStats.peek_top_of_room_stack() == world:
			ySort.remove_child(player)
		else:
			origin_scene.remove_child(player)
		destination.add_child(player)
		player.spawn_player()
		WorldStats.add_room_to_stack(destination)
		pause_signals = false
	

func _on_Scene_exited():
	if not pause_signals:
		pause_signals = true
		var origin = WorldStats.remove_room_from_stack()
		origin.remove_child(player)
		remove_child(origin)
		origin.queue_free()
		if WorldStats.peek_top_of_room_stack() == world:
			ySort.add_child(player)
			ySort.move_child(player, 0)
			add_child(world)
		else:
			var destination = WorldStats.peek_top_of_room_stack()
			destination.add_child(player)
			add_child(destination)
		player.spawn_player()
		pause_signals = false

func connect_camera_remote_transform(destination):
	for child in destination.get_children():
		if child is Camera2D:
			
			break
