extends StaticBody2D

export var signal_code : String

enum states {
	RED,
	BLUE,
	CENTER,
}

onready var interaction_zone = $InteractionZone
onready var anim_player = $AnimationPlayer

var state = states.RED

func _ready():
	interaction_zone.connect("interaction_finished", self, "toggle_switch")

func toggle_switch(node):
	anim_player.stop()
	match state:
		states.RED:
			anim_player.play("red_to_blue")
			SignalBus.emit_signal("red_blue_switch_state_changed", signal_code, states.BLUE, states)
			state = states.BLUE
		states.BLUE:
			anim_player.play("blue_to_red")
			SignalBus.emit_signal("red_blue_switch_state_changed", signal_code, states.RED, states)
			state = states.RED
