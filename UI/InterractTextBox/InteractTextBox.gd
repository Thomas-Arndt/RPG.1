extends CanvasLayer

var options : Array = ["Option 1", "Option 2", "Option 3", "Option 4"]

onready var scroll_container = $MarginContainer/TextBoxContainer/MarginContainer/ScrollContainer
onready var option_v_box = $MarginContainer/TextBoxContainer/MarginContainer/ScrollContainer/VBoxContainer

var option_container = preload("res://UI/InterractTextBox/InteractTextBoxOption.tscn")

func _ready():
	display_options()

func display_options():
	for option in options:
		var new_option_container = option_container.instance()
		new_option_container.set_text(option)
		option_v_box.add_child(new_option_container)
