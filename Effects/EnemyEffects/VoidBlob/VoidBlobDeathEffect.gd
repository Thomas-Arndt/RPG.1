extends Area2D

signal animation_finished

onready var full_sprite = $FullSprite
onready var anim_player = $AnimationPlayer

func _ready():
	if WorldStats.DIMENSION == get_dimension():
		full_sprite.visible = true
	else:
		full_sprite.visible = false
	anim_player.play("death")

func _on_animation_finish():
	emit_signal("animation_finished")
	queue_free()

func get_dimension():
	pass
