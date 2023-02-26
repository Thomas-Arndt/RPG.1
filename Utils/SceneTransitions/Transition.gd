extends CanvasLayer

signal finished

onready var anim_player = $AnimationPlayer

func _on_animation_finished():
	emit_signal("finished")

func scene_out():
	anim_player.play("scene_out")

func scene_in():
	anim_player.play("scene_in")
