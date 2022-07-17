extends Node

onready var world = $World
onready var ySort = $World/YSort
onready var player = $World/YSort/Player

var destination: Node2D = null

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
	
func _on_Scene_Link_entered(destination_reference):
	remove_child(world)
	destination = destination_reference.instance()
	add_child(destination)
	move_child(destination, 0)
	

func _on_Scene_exited():
	remove_child(destination)
	destination.queue_free()
	add_child(world)
	move_child(world, 0)
	player.spawn_player()
