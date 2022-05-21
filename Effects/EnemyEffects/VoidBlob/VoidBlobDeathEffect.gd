extends Area2D

onready var full_sprite = $FullSprite
onready var anim_player = $AnimationPlayer

func _ready():
	if WorldStats.DIMENSION == get_dimension():
		full_sprite.visible = true
	else:
		full_sprite.visible = false
	anim_player.play("death")

func _on_animation_finish():
	queue_free()

func get_dimension():
	pass
