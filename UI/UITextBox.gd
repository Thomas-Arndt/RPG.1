extends CanvasLayer

const CHAR_READ_RATE = 0.05

onready var text_box_container = $TextBoxContainer
onready var end_symbol = $TextBoxContainer/MarginContainer/HBoxContainer/End
onready var label = $TextBoxContainer/MarginContainer/HBoxContainer/Label

enum States {
	READY,
	READING,
	FINISHED
}

var state = States.READY
var complete = true
var text_queue = []

func _ready():
	hide_text_box()

func _process(delta):
	match state:
		States.READY:
			if !text_queue.empty():
				end_symbol.text = ""
				display_text()
		States.READING:
			if Input.is_action_just_pressed("attack"):
				label.percent_visible = 1.0
				$Tween.remove_all()
				end_symbol.text = "v"
				change_state(States.FINISHED)
		States.FINISHED:
			if Input.is_action_just_pressed("attack"):
				change_state(States.READY)
				if len(text_queue) == 0:
					complete = true
					hide_text_box()

func hide_text_box():
	end_symbol.text = ""
	label.text = ""
	text_box_container.hide()

func show_text_box():
	text_box_container.show()

func display_text():
	var next_text = text_queue.pop_front()
	label.text = next_text
	label.percent_visible = 0.0
	change_state(States.READING)
	show_text_box()
	$Tween.interpolate_property(label, "percent_visible", 0.0, 1.0, len(next_text) * CHAR_READ_RATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func change_state(next_state):
	state = next_state
	match state:
		States.READY:
			print("Now in READY state.")
		States.READING:
			print("Now in READING state.")
		States.FINISHED:
			print("Now in FINISHED state.")
			
func queue_text(text_array):
	complete = false
	for text in text_array:
		print(text)
		text_queue.push_back(text)
	display_text()

func _on_Tween_tween_completed(object, key):
	end_symbol.text = "v"
	change_state(States.FINISHED)