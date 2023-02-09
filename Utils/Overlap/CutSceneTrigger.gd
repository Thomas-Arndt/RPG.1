extends Node2D

var action = 0
var triggered = false
var player = null

onready var actor_controllers = $ActorControllers

func _ready():
	for actor in actor_controllers.get_children():
		actor.connect("finished", self, "_on_Actor_finished")
		actor.connect("release_player", self, "release_player")

func _on_Area2D_area_entered(area):
	player = area.get_parent().get_parent()
	if not triggered:
		player.paused(true)
		action += 1
		triggered = true
		for actor in actor_controllers.get_children():
			actor.run_cut_scene()

func _on_Actor_finished():
	if len(actor_controllers.get_children()) > action:
		action += 1
	# Probably need to get rid of this when saving logic is added
	else:	
		queue_free()
	
func release_player():
	player.paused(false)

