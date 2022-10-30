extends GridContainer

func _ready():
	Inventory.connect("item_changed", self, "_on_items_changed")
	Inventory.make_items_unique()
	update_inventory_display()

func update_inventory_display():
	for item_index in Inventory.inventory.size():
		update_inventory_slot_display(item_index)

func update_inventory_slot_display(item_index):
	var inventorySlotDisplay = get_child(item_index)
	var item = Inventory.inventory[item_index]
	if inventorySlotDisplay != null:
		inventorySlotDisplay.display_item(item)

func _on_items_changed(indices):
	for item_index in indices:
		update_inventory_slot_display(item_index)
		
func _unhandled_input(event):
	if event.is_action_released("ui_left_mouse"):
		if Inventory.drag_data is Dictionary:
			Inventory.set_item(Inventory.drag_data.item_index, Inventory.drag_data.item)
	if event.is_action_pressed("belt_1"):
		if Inventory.inventory[0] is Item:
			Inventory.inventory[0].action()
			Inventory.inventory[0].quantity -= 1
			if Inventory.inventory[0].quantity <= 0:
				Inventory.inventory[0] = null
		Inventory.emit_signal("item_changed", [0])
