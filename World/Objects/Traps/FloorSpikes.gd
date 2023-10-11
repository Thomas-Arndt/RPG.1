extends StaticBody2D

export var trigger_delay: float = 1
export var frequency: float = 0

var active = true

onready var anim_player = $AnimationPlayer
onready var detection_zone = $PlayerDetectionZone
onready var timer = $Timer

func _ready():
	if frequency != 0 and trigger_delay == 0:
		active = false
		_on_Timer_timeout()
	elif frequency != 0 and trigger_delay != 0:
		_on_Player_detected()
	else:
		detection_zone.connect("body_entered", self, "_on_Player_detected")

func _on_Player_detected():
	if active == true:
		active = false
		timer.start(trigger_delay)

func _on_Timer_timeout():
	anim_player.queue("extend")
	anim_player.queue("retract")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "retract":
		if frequency != 0:
			timer.start(frequency)
		else:
			active = true
