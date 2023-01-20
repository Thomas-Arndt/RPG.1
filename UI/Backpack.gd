extends CanvasLayer

onready var background = $BackpackBackground
onready var inventory = $InventoryDisplay
onready var inventory_cursor = $InventoryCursor
onready var label = $Label

var state = false

func _ready():
	background.rect_position.y = 158
	inventory.rect_position.y = 162
	inventory_cursor.rect_position.y = 162
	label.rect_position.y = 147
	inventory_cursor.visible = false
	
func _process(delta):
	if state:
		if Input.is_action_just_pressed("ui_up"):
			inventory_cursor.update_cursor_location(-4)
		if Input.is_action_just_pressed("ui_right"):
			inventory_cursor.update_cursor_location(1)
		if Input.is_action_just_pressed("ui_down"):
			inventory_cursor.update_cursor_location(4)
		if Input.is_action_just_pressed("ui_left"):
			inventory_cursor.update_cursor_location(-1)
	
func toggle_backpack():
	state = !state
	if state:
		background.rect_position.y = 76
		inventory.rect_position.y = 80
		inventory_cursor.rect_position.y = 80
		label.rect_position.y = 65
		inventory_cursor.visible = true
	else:
		background.rect_position.y = 158
		inventory.rect_position.y = 162
		inventory_cursor.rect_position.y = 162
		label.rect_position.y = 147
		inventory_cursor.visible = false
