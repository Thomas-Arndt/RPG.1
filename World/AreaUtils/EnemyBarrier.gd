extends StaticBody2D

export var signal_code : String

onready var collision_shape = $CollisionShape2D
onready var enemy_detector = $EnemyDetector/CollisionShape2D

var active = true

func _ready():
	SignalBus.connect("activate_barrier", self, "_on_Activate_Barrier")
	SignalBus.connect("deactivate_barrier", self, "_on_Deactivate_Barrier")

func _on_Activate_Barrier(code):
	if code == signal_code:
		collision_shape.set_deferred("disabled", false)
		enemy_detector.set_deferred("disabled", false)
		active = true
	
func _on_Deactivate_Barrier(code):
	if code == signal_code:
		collision_shape.set_deferred("disabled", true)
		enemy_detector.set_deferred("disabled", true)
		active = false

func _on_EnemyDetector_body_entered(body):
	if active and body.has_method("collide_with_barrier"):
		body.collide_with_barrier(signal_code)
