extends CanvasLayer

const CHAR_READ_RATE = 0.05

signal finished

onready var text_box_container = $MarginContainer/TextBoxContainer
onready var end_symbol = $MarginContainer/TextBoxContainer/MarginContainer/HBoxContainer/End
onready var label = $MarginContainer/TextBoxContainer/MarginContainer/HBoxContainer/Label
onready var source_label = $SourceLabel

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
	if not complete:
		match state:
			States.READY:
				if !text_queue.empty():
					end_symbol.text = ""
					display_text()
			States.READING:
				if Input.is_action_just_pressed("quick_action_4") and label.percent_visible > 0.05:
					label.percent_visible = 1.0
					$Tween.remove_all()
					end_symbol.text = "v"
					change_state(States.FINISHED)
			States.FINISHED:
				if Input.is_action_just_pressed("quick_action_4"):
					change_state(States.READY)
					if len(text_queue) == 0:
						hide_text_box()
						yield(get_tree().create_timer(0.2),"timeout")
						emit_signal("finished")
						complete = true

func hide_text_box():
	end_symbol.text = ""
	label.text = ""
	label.percent_visible = 0.0
	text_box_container.hide()
	source_label.hide()

func show_text_box():
	text_box_container.show()
	source_label.show()

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
			
func queue_text(text_array, source: String = source_label.text):
	complete = false
	source_label.text = source
	for text in text_array:
		text_queue.push_back(text)
	display_text()

func set_speaker_name(speaker):
	source_label.text = speaker

func _on_Tween_tween_completed(object, key):
	end_symbol.text = "v"
	change_state(States.FINISHED)
