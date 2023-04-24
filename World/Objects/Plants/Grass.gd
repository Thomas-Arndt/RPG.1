extends Node2D

const GrassEffect = preload("res://Effects/ObjectEffects/GrassEffect.tscn")

func run_Grass_Effect():
	var grassEffect = GrassEffect.instance()
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position

func _on_HurtBox_area_entered(area):
	run_Grass_Effect()
	queue_free()
