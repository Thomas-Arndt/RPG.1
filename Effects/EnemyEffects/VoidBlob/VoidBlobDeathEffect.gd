extends Area2D

signal animation_finished

onready var full_sprite = $FullSprite
onready var anim_player = $AnimationPlayer

export var death : bool = true

func _ready():
	if WorldStats.DIMENSION == get_dimension():
		full_sprite.visible = true
	else:
		full_sprite.visible = false
	if death:
		anim_player.play("death")
	else:
		anim_player.play("enter")

func _on_animation_finish():
	emit_signal("animation_finished")
	queue_free()

func get_dimension():
	pass
