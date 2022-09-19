extends Node

onready var world = $World
onready var ySort = $World/YSort
onready var player = $World/YSort/Player

var destination: Node2D = null
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
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		player.spawn_player()
	
func _on_Scene_Link_entered(destination_reference, source):
	if not pause_signals:
		pause_signals = true
		remove_child(world)
		destination = destination_reference.instance()
		add_child(destination)
		move_child(destination, 0)
		ySort.remove_child(player)
		destination.add_child(player)
		player.spawn_player()
		pause_signals = false
	

func _on_Scene_exited():
	if not pause_signals:
		pause_signals = true
		destination.remove_child(player)
		remove_child(destination)
		destination.queue_free()
		ySort.add_child(player)
		ySort.move_child(player, 0)
		add_child(world)
		player.spawn_player()
		pause_signals = false
