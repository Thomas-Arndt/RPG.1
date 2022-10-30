extends CanvasLayer

onready var background = $BackpackBackground
onready var inventory = $InventoryDisplay
onready var label = $Label

var state = false

func _ready():
	background.rect_position.y = 157
	inventory.rect_position.y = 161
	label.rect_position.y = 146


func toggle_backpack():
	state = !state
	if state:
		background.rect_position.y = 76
		inventory.rect_position.y = 80
		label.rect_position.y = 65
	else:
		background.rect_position.y = 157
		inventory.rect_position.y = 161
		label.rect_position.y = 146
