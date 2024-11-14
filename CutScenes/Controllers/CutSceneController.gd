extends Node2D

signal finished
signal release_player

export (PackedScene) var actor_reference = null
export (NodePath) var actor_path = null

var actor : Node2D = null
var choreography : Array = []
var scene_started = false
var is_acting = false
var is_speaking = false
var emote = null
var displacement : Vector2

const exclamation = preload("res://Effects/Emotes/Exclamation.tscn")

onready var tween : Tween = $Tween
onready var timer = $Timer

enum {
	ENTER,
	MOVE_TO,
	SEEK_PLAYER,
	EXIT,
	DIALOGUE,
	WAIT,
	RELEASE_ACTOR,
	RELEASE_PLAYER,
	VISIBLE_OFF,
	VISIBLE_ON,
	CUSTOM,
	DELETE_ACTOR,
	PAUSE_FOR_DIALOGUE,
	EMOTE,
	MOVE_CAMERA,
	RETURN_CAMERA,
}

func _ready():
	UI.TextBox.connect("finished", self, "dialogue_complete")
	package_choreography()

func run_cut_scene():
	if len(choreography) > 0 and not is_acting:
		var action = choreography.pop_front()
		match action[0]:
			ENTER:
				enter_actor(action[1])
			MOVE_TO:
				move_actor_to(action[1], action[2], action[3])
			SEEK_PLAYER:
				seek_player(action[1], action[2], action[3], action[4])
			EXIT:
				exit_actor()
			DIALOGUE:
				start_dialogue(action[1], action[2])
			WAIT:
				start_timer(action[1])
			RELEASE_ACTOR:
				release_actor()
			RELEASE_PLAYER:
				release_player()
			VISIBLE_ON:
				toggle_visible_on()
			VISIBLE_OFF:
				toggle_visible_off()	
			CUSTOM:
				custom_actions(action[1], action[2])
			DELETE_ACTOR:
				delete_actor()
			PAUSE_FOR_DIALOGUE:
				pause_for_dialogue()
			EMOTE:
				emote(action[1], action[2])
			MOVE_CAMERA:
				set_displacement("set", action[1])
				move_camera(action[2], action[3])
			RETURN_CAMERA:
				set_displacement("return")
				move_camera(action[1], action[2])
	else:
		cut_scene_finished()

func enter_actor(position : Vector2) -> void:
	if actor_reference != null:
		actor = actor_reference.instance()
		actor.global_position = position
		if actor.has_method("state_machine_pause"):
			actor.state_machine_pause()
		get_tree().get_nodes_in_group("Mobs")[0].add_child(actor)
	else:
		actor = get_node(actor_path)
		if actor.has_method("state_machine_pause") and not actor is Player:
			actor.state_machine_pause()
		toggle_visible_on()
	run_cut_scene()

func move_actor_to(destination : Vector2, duration: float, move_animation_name: String):
	if actor.anim_player:
		actor.anim_player.play(move_animation_name)
	if actor.has_method("flip_sprite"):
		actor.flip_sprite(destination.x - global_position.x)
	tween.interpolate_property(actor, "global_position", actor.global_position, destination, duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	is_acting = true
	tween.start()

func seek_player(start_position: Vector2, distance: int, duration: float, move_animation_name: String):
	var destination = start_position.move_toward(get_tree().get_nodes_in_group("Player")[0].position, distance)
	if actor.anim_player:
		actor.anim_player.play(move_animation_name)
	if actor.has_method("flip_sprite"):
		actor.flip_sprite(destination.x - global_position.x)
	tween.interpolate_property(actor, "global_position", actor.global_position, destination, duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	is_acting = true
	tween.start()

func exit_actor():
	actor.get_parent().remove_child(actor)
	actor.queue_free()
	run_cut_scene()
	
func release_actor():
	actor.position = actor.global_position
	if actor.has_method("state_machine_run"):
		actor.state_machine_run()
	run_cut_scene()

func delete_actor():
	actor.queue_free()
	run_cut_scene()
	
func start_timer(duration : float):
	is_acting = true
	timer.start(duration)

func start_dialogue(text_array, speaker):
	is_acting = true
	is_speaking = true
	UI.TextBox.queue_text(text_array, speaker)

func toggle_visible_on():
	actor.visible = true
	run_cut_scene()

func toggle_visible_off():
	actor.visible = false
	run_cut_scene()
	
func cut_scene_finished():
	emit_signal("finished")

func release_player():
	emit_signal("release_player")
	run_cut_scene()

func emote(type, action):
	match type:
		"exclamation":
			if action == "show":
				emote = exclamation.instance()
				actor.add_child(emote)
				emote.position.y -= 32
				run_cut_scene()
			elif action == "hide":
				if emote != null:
					emote.queue_free()
					run_cut_scene()
		"question":
			pass

func set_displacement(mode, location = Vector2.ZERO):
	if mode == "set":
		displacement = (location - (actor.global_position)) * .75
	elif mode == "return":
		displacement = -displacement

func move_camera(scene, duration):
	var remote_transform : RemoteTransform2D = get_node("/root/Game/" + scene + "/YSort/Player/RemoteTransform2D")
	tween.interpolate_property(remote_transform, "position", remote_transform.position, remote_transform.position + displacement, duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	is_acting = true
	tween.start()

func dialogue_complete():
	if is_speaking:
		is_speaking = false
		is_acting = false
		run_cut_scene()

func pause_for_dialogue():
	is_acting = true
	is_speaking = true

func _on_Tween_tween_all_completed():
	if is_acting:
		if not actor == null and actor.anim_player.has_animation("idle"):
			actor.anim_player.play("idle")
		#elif not actor == null and actor.anim_player.has_animation("idle_down"):
		#	actor.anim_player.play("idle_down")
		is_acting = false
		run_cut_scene()
	
func _on_Timer_timeout():
	is_acting = false
	run_cut_scene()

func package_choreography():
	pass

func custom_actions(action_name, args):
	pass
