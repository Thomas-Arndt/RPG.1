extends GridContainer

func _ready():
	Inventory.connect("item_changed", self, "_on_items_changed")
	update_inventory_display()

func toggle_inventory_display():
	update_inventory_display()
	self.visible = !self.visible

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
