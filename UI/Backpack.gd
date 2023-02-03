extends CanvasLayer

onready var inventory_cursor = $InventoryCursor
onready var inventory_display = $InventoryDisplay
onready var crafting_menu = $CraftingMenu
onready var recipe_list = $CraftingMenu/RecipeList
onready var tween = $Tween

var state = false
var crafting = false

func _ready():
	inventory_cursor.visible = false
	
func _process(delta):
	if state and not crafting:
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
		if Input.is_action_just_pressed("quick_action_2"):
			toggle_crafting_menu()
	elif state and crafting:
		if Input.is_action_just_pressed("ui_up"):
			recipe_list.update_cursor_index(-1)
		if Input.is_action_just_pressed("ui_down"):
			recipe_list.update_cursor_index(1)
		if Input.is_action_just_pressed("quick_action_4"):
			recipe_list.craft_item()
		if Input.is_action_just_pressed("quick_action_2"):
			toggle_crafting_menu()
	
func toggle_backpack():
	state = !state
	if state:
		inventory_cursor.visible = true
		tween.interpolate_property(self, "offset:y", offset.y, -82, 0.8, Tween.TRANS_CIRC ,Tween.EASE_OUT)
	else:
		inventory_cursor.snap_item()
		inventory_cursor.visible = false
		tween.interpolate_property(self, "offset:y", offset.y, 0, 0.8, Tween.TRANS_CIRC ,Tween.EASE_OUT)
		if crafting:
			tween.interpolate_property(crafting_menu, "rect_position:x", crafting_menu.rect_position.x, 0, 0.8, Tween.TRANS_CIRC, Tween.EASE_OUT)
			crafting = !crafting
	tween.start()
		
func toggle_crafting_menu():
	crafting = !crafting
	if state:
		if crafting:
			inventory_cursor.visible = false
			tween.interpolate_property(crafting_menu, "rect_position:x", crafting_menu.rect_position.x, 83, 0.8, Tween.TRANS_CIRC, Tween.EASE_OUT)
		else:
			inventory_cursor.visible = true
			tween.interpolate_property(crafting_menu, "rect_position:x", crafting_menu.rect_position.x, 0, 0.8, Tween.TRANS_CIRC, Tween.EASE_OUT)
		tween.start()
