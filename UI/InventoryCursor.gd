extends GridContainer

var cursor_item = preload("res://UI/InventoryCursor.tres")

var cursor = null;
var cursor_index: int = 0
var selected_item_index: int = 0

func _ready():
	cursor = cursor_item;
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
	if new_index > len(get_children())-1 and d_index == 4:
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
	
func set_selected_item():
	selected_item_index = cursor_index;
	if cursor == cursor_item:
		cursor = Inventory.set_item(cursor_index, null)
	else:
		cursor = Inventory.set_item(cursor_index, cursor)
	if cursor == null:
		cursor = cursor_item
	update_cursor_display()

func snap_item():
	if cursor != cursor_item:
		if (Inventory.inventory[selected_item_index] == null):
			Inventory.set_item(selected_item_index, cursor)
		else:
			var index = 0;
			while index < len(Inventory.inventory):
				if Inventory.inventory[index] == null:
					Inventory.set_item(index, cursor)
					index = len(Inventory.inventory)
				index += 1
		cursor = cursor_item
	update_cursor_display()
