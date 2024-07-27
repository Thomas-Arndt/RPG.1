extends Node2D

export (String) var signal_code

onready var animation_player = $AnimationPlayer

var is_closed: bool = true

func _ready():
	SignalBus.connect("event_switch", self, "on_Switch_Event")

func on_Switch_Event(code, switch_event):
	if signal_code == code:
		if switch_event == "open":
			SignalBus.emit_signal("deactivate_barrier", code)
			animation_player.play("open")
			is_closed = false
		elif switch_event == "close" and !is_closed:
			SignalBus.emit_signal("activate_barrier", code)
			animation_player.play("close")
			is_closed = true
