extends GridContainer

func _ready():
	Inventory.connect("item_changed", self, "_on_items_changed")
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

func _input(event):
	if event.is_action_pressed("quick_action_1"):
		process_action(0)

func process_action(index):
	if Inventory.inventory[index] is Item:
		Inventory.inventory[index].action()
		if Inventory.inventory[index].type == "potion":
			Inventory.inventory[index].quantity -= 1
		if Inventory.inventory[index].quantity <= 0:
			Inventory.inventory[index] = null
	Inventory.emit_signal("item_changed", [index])
