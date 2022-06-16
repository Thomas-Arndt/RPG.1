extends StaticBody2D

onready var Footprint = $Footprint

func _ready():
	Footprint.set_deferred("disabled", false)

func _on_AutomaticEntry_body_entered(body):
	Footprint.set_deferred("disabled", true)

func _on_AutomaticEntry_body_exited(body):
	Footprint.set_deferred("disabled", false)
