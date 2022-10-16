extends Node2D

signal next_action

export (PackedScene) var actor_reference = null

var actor : Node = null
var choreography : Array = []

onready var detection_zone = $DetectionZonePivot/DetectionZone
onready var tween = $Tween
onready var timer = $Timer

enum {
	ENTER,
	MOVE_TO,
	EXIT
}

func _ready():
	connect("next_action", self, "run_cut_scene")
	package_choreography()
	run_cut_scene()

func run_cut_scene():
	if len(choreography) > 0:
		var action = choreography.pop_front()
		match action[0]:
			ENTER:
				enter_actor(action[1])
			MOVE_TO:
				move_actor_to(action[1], action[2])
			EXIT:
				exit_actor()
	else:
		cut_scene_finished()

func enter_actor(position : Vector2) -> void:
	if actor_reference != null:
		actor = actor_reference.instance()
		actor.global_position = position
		add_child(actor)
		emit_signal("next_action")

func move_actor_to(destination : Vector2, duration: float):
		tween.interpolate_property(actor, "global_position", global_position, destination, duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()

func exit_actor():
	remove_child(actor)
	
func start_timer(duration : int):
	timer.start(duration)

func cut_scene_finished():
	queue_free()

func _on_Tween_tween_all_completed():
	run_cut_scene()
	
func _on_Timer_timeout():
	run_cut_scene()

func package_choreography():
	choreography.append([ENTER, Vector2(-27, 680)])
	choreography.append([MOVE_TO, Vector2(-27, 600), 4])



