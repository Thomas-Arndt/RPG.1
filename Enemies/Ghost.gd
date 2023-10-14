extends KinematicBody2D

onready var anim_player = $AnimationPlayer
onready var timer = $Timer
onready var collision_shape = $CollisionShape2D

var test : bool = true

func _ready():
	apparate()
	
func apparate():
	anim_player.queue("apparate")
	anim_player.queue("idle")
	timer.start(6)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	if test:
		collision_shape.disabled = true
		anim_player.stop()
		anim_player.play("disapparate")
		timer.start(6)
	else:
		collision_shape.disabled = false
		apparate()
	test = !test
