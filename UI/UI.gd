extends Node2D

onready var GoldDisplay: Node = $GoldDisplay
onready var TextBox: Node = $UITextBox
onready var HealthBar: Node = $HealthBar
onready var Backpack: Node = $Backpack
onready var MainMenu: Node = $MainMenu

enum states {
	TITLE,
	MAIN,
	OVERWORLD,
	CUTSCENE,
}

var state = states.TITLE

func _ready():
	apply_state()

func set_state(new_state):
	state = new_state
	apply_state()

func apply_state():
	match state:
		states.TITLE:
			GoldDisplay.hide()
			TextBox.hide_text_box()
			HealthBar.hide()
			Backpack.hide()
			MainMenu.hide()
		states.MAIN:
			GoldDisplay.hide()
			TextBox.hide_text_box()
			HealthBar.hide()
			Backpack.hide()
			MainMenu.show()
		states.OVERWORLD:
			GoldDisplay.show()
			TextBox.hide_text_box()
			HealthBar.show()
			Backpack.show()
			MainMenu.hide()
		states.CUTSCENE:
			GoldDisplay.hide()
			TextBox.hide_text_box()
			HealthBar.hide()
			Backpack.hide()
			MainMenu.hide()
