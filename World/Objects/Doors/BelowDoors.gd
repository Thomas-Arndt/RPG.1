extends StaticBody2D

export var signal_code : String

onready var anim_player = $AnimationPlayer

enum {
	OPEN,
	CLOSED
}

var state = CLOSED

func _ready():
	SignalBus.connect("red_blue_switch_state_changed", self, "on_red_blue_switch_changed")

func open():
	anim_player.stop()
	anim_player.play("open")
	state = OPEN

func close():
	anim_player.stop()
	anim_player.play("close")
	state = CLOSED
	
func on_red_blue_switch_changed(signal_code, state, states):
	if signal_code == self.signal_code:
		match state:
			states.RED:
				close()
			states.BLUE:
				open()
