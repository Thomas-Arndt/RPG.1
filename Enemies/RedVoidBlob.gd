extends "res://Enemies/VoidBlob.gd"

const DeathEffect = preload("res://Effects/EnemyEffects/VoidBlob/RedVoidBlobDeathEffect.tscn")

func match_dimension():
	if WorldStats.DIMENSION == true:
		full_sprite.visible = true
		hurt_box.monitorable = true
		hurt_box.monitoring = true
	else:
		full_sprite.visible = false
		hurt_box.monitorable = false
		hurt_box.monitoring = false

func get_dimension():
	return false

func death_animation():
	var death_effect = DeathEffect.instance()
	get_parent().add_child(death_effect)
	death_effect.global_position = global_position
