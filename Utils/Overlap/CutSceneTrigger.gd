extends Node2D

export var active : bool = false

var action = 0
var triggered = false
var player = null

onready var actor_controllers = $ActorControllers
onready var trigger_area = $TriggerArea

func _ready():
	for actor in actor_controllers.get_children():
		actor.connect("finished", self, "_on_Actor_finished")
		actor.connect("release_player", self, "release_player")

func _on_Area2D_area_entered(area):
	if active and not triggered:
		start_cutscene(get_tree().get_nodes_in_group("Player")[0])

func start_cutscene(node):
	if node != null:
		player = node
		player.paused(true)
		action += 1
		triggered = true
		for actor in actor_controllers.get_children():
			actor.run_cut_scene()

func _on_Actor_finished():
	if len(actor_controllers.get_children()) > action:
		action += 1
	
func release_player():
	player.paused(false)
	
func reset():
	action = 0
	active = true
	triggered = false

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"active" : active,
		"triggered": triggered
	}
	return save_dict
