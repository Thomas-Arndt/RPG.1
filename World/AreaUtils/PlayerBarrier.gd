extends StaticBody2D

export var signal_code : String

onready var collision_shape = $CollisionShape2D

func _ready():
	SignalBus.connect("activate_barrier", self, "_on_Activate_Barrier")
	SignalBus.connect("deactivate_barrier", self, "_on_Deactivate_Barrier")

func _on_Activate_Barrier(code):
	if code == signal_code:
		collision_shape.set_deferred("disabled", false)
	
func _on_Deactivate_Barrier(code):
	if code == signal_code:
		collision_shape.set_deferred("disabled", true)
