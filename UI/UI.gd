extends Node2D

onready var GoldDisplay: Node = $GoldDisplay
onready var TextBox: Node = $UITextBox
onready var HealthBar: Node = $HealthBar
onready var Backpack: Node = $Backpack
onready var MainMenu: Node = $MainMenu
onready var QuestLog: Node = $QuestLog

enum states {
	TITLE,
	MAIN,
	OVERWORLD,
	CUTSCENE,
	CONTINUE,
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
			QuestLog.hide()
		states.MAIN:
			GoldDisplay.hide()
			TextBox.hide_text_box()
			HealthBar.hide()
			Backpack.hide()
			MainMenu.show()
			QuestLog.hide()
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
			QuestLog.hide()
