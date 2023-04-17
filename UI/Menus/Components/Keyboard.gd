extends Control

const CHARACTER_LIST_UPPER : Array = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
const CHARACTER_LIST_LOWER : Array = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
const SPECIALS : Array = ["Space", "Delete", "Shift", "OK"]

var Key = preload("res://UI/Menus/Components/Key.tscn")

onready var grid_container = $VBoxContainer/GridContainer
onready var specials_container = $VBoxContainer/HBoxContainer

enum states {
	UPPER,
	LOWER
}

var state = states.UPPER

func _ready():
	update_keyboard()
	for key in SPECIALS:
		var new_key = Key.instance()
		new_key.value = key
		new_key.action = "keyboard_key_pressed"
		new_key.text = key
		specials_container.add_child(new_key)

func update_keyboard():
	clear_keys()
	var character_list
	if state == states.UPPER:
		character_list = CHARACTER_LIST_UPPER
	else:
		character_list = CHARACTER_LIST_LOWER
	for character in character_list:
		var new_key = Key.instance()
		new_key.value = character
		new_key.action = "keyboard_key_pressed"
		new_key.text = character
		grid_container.add_child(new_key)
	

func clear_keys():
	for child in grid_container.get_children():
		child.queue_free()

func toggle_case():
	if state == states.UPPER:
		state = states.LOWER
	else:
		state = states.UPPER
	update_keyboard()
	
