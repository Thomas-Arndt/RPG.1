extends CanvasLayer

onready var inventory_cursor = $InventoryCursor
onready var inventory_display = $InventoryDisplay
onready var tween = $Tween

var state = false

func _ready():
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
		if Input.is_action_just_pressed("quick_action_4"):
			inventory_cursor.set_selected_item()
	
func toggle_backpack():
	state = !state
	tween.remove_all()
	if state:
		inventory_cursor.visible = true
		tween.interpolate_property(self, "offset:y", offset.y, -82, 0.8, Tween.TRANS_CIRC ,Tween.EASE_OUT)
	else:
		inventory_cursor.snap_item()
		inventory_cursor.visible = false
		tween.interpolate_property(self, "offset:y", offset.y, 0, 0.8, Tween.TRANS_CIRC ,Tween.EASE_OUT)
	tween.start()
		
