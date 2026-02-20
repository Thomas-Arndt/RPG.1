extends StaticBody2D

export var signal_code : String
export var red_active : bool = true
export var green_active : bool = true

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
	SignalBus.connect("event_switch", self, "on_Switch_Event")

func toggle_switch(node):
	if (red_active and WorldStats.DIMENSION == WorldStats.Dimensions.Red) or (green_active and WorldStats.DIMENSION == WorldStats.Dimensions.Green):
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

func on_Switch_Event(code, switch_event):
	if signal_code == code:
		if switch_event == "open":
			anim_player.play("red_to_blue")
			state = states.BLUE
		elif switch_event == "close":
			anim_player.play("blue_to_red")
			state = states.RED
