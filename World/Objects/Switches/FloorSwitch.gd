extends StaticBody2D

export (Array, String) var on_signal_codes
export (Array, String) var off_signal_codes
export (bool) var heavyweight = false

enum STATES {
	ON,
	OFF
}

var state:int = STATES.OFF
var rect_size = Vector2(14, 15)

onready var sprite = $Sprite

func _ready():
	sprite.region_rect = Rect2(Vector2(0, 143), rect_size)


func _on_Area2D_body_entered(body):
	if ((heavyweight and body is Push_Object) or not heavyweight):
		state = STATES.ON
		sprite.region_rect = Rect2(Vector2(16, 143), rect_size)
		for code in on_signal_codes:
			SignalBus.emit_signal("floor_switch", code, state)
		get_tree().get_nodes_in_group("World")[0].save_scene()


func _on_Area2D_body_exited(body):
	state = STATES.OFF
	sprite.region_rect = Rect2(Vector2(0, 143), rect_size)
	#SignalBus.emit_signal("floor_switch", signal_code, state, STATES)	
