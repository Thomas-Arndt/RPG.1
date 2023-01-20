extends GridContainer

var cursor = preload("res://UI/InventoryCursor.tres")

var cursor_index: int = 0

func _ready():
	update_cursor_display()	

func update_cursor_display():
	for item_index in len(get_children()):
		if item_index == cursor_index:
			update_inventory_slot_display(item_index, cursor)
		else:
			update_inventory_slot_display(item_index, null)

func update_inventory_slot_display(item_index, item):
	var inventorySlotDisplay = get_child(item_index)
	if inventorySlotDisplay != null:
		inventorySlotDisplay.display_item(item)

func update_cursor_location(d_index):
	var new_index = cursor_index + d_index
	if new_index > len(get_children()) and d_index == 4:
		cursor_index -= 16
	elif new_index < 0 and d_index == -4:
		cursor_index += 16
	elif cursor_index%4 == 0 and d_index == -1:
		cursor_index += 3
	elif cursor_index%4 == 3 and d_index == 1:
		cursor_index -= 3
	else:
		cursor_index = new_index

	update_cursor_display()
	
func get_cursor_index():
	return cursor_index
