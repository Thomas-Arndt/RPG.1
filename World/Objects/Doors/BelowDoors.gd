extends StaticBody2D

onready var anim_player = $AnimationPlayer

enum {
	OPEN,
	CLOSED
}

var state = CLOSED

func open():
	anim_player.stop()
	anim_player.play("open")
	state = OPEN

func close():
	anim_player.stop()
	anim_player.play("close")
	state = CLOSED
	
func _process(delta):
	if Input.is_action_just_pressed("quick_action_4"):
		if state == OPEN:
			close()
		elif state == CLOSED:
			open()
