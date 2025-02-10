extends Node
class_name CutSceneTriggerAction

signal finished

onready var actor_controllers = $ActorControllers

export var active: bool

var triggered: bool = false
var player: Node = null
var action: int = 0

func _ready():
	for actor in actor_controllers.get_children():
		actor.connect("finished", self, "_on_Actor_finished")
		actor.connect("release_player", self, "release_player")

func interact() -> void:
	if active and not triggered:
		start_cutscene(get_tree().get_nodes_in_group("Player")[0])

func start_cutscene(node):
	if node != null:
		player = node
		player.paused(true)
		action += 1
		triggered = true
		for actor in actor_controllers.get_children():
			actor.package_choreography()
			actor.run_cut_scene()
		
func release_player():
	player.paused(false)

func save():
	var save_dict = {
		"filename" : get_filename(),
		"path" : get_path(),
		"class" : "CompletedQuestAction",
		"active" : active,
	}
	return save_dict
