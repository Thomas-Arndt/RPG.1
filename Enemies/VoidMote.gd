extends KinematicBody2D
class_name VoidMote

export var min_jumps = 1
export var max_jumps = 5
export var throw_height = 20

var jumps = 1

onready var tween = $Tween
onready var sprite = $AnimatedSprite
onready var shadow = $ShadowSprite
onready var wander_controller = $WanderController
onready var timer = $Timer

func _ready():
	randomize()
	jumps = randi()%(max_jumps-min_jumps) + min_jumps

func throw(destination):
	tween.interpolate_property(self, "global_position", global_position, destination, 0.35, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.interpolate_method(self, "animate_arc", 0, 1, 0.35, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func animate_arc(progress):
	var sprite_height = (throw_height * pow(sin(progress * PI), 0.7))+9
	var shadow_scale = 1.0 - sprite_height / throw_height * 0.5
	sprite.position.y = -sprite_height
	shadow.scale = Vector2(shadow_scale, shadow_scale)

func _on_Timer_timeout():
	if jumps == 0:
		queue_free()
	else:
		wander_controller.start_position = global_position
		wander_controller.update_target_position()
		throw(wander_controller.target_position)


func _on_Tween_tween_all_completed():
	jumps -= 1
	timer.start(1)	
