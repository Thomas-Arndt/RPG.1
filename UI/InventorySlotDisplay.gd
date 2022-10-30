extends CenterContainer

onready var itemTextureRect = $ItemTextureRect

func display_item(item):
	if item is Item:
		itemTextureRect.texture = item.texture
	else:
		itemTextureRect.texture = null


func get_drag_data(_position):
	var item_index = get_index()
	var item = Inventory.remove_item(item_index)
	if item is Item:
		var data = {}
		data.item = item
		data.item_index = item_index
		data.texture = item.texture
		data.itemType = item.type
		var dragPreview = TextureRect.new()
		dragPreview.texture = item.texture
		set_drag_preview(dragPreview)
		Inventory.drag_data = data
		return data

func can_drop_data(_position, data):
	return data is Dictionary && data.has("item")


func drop_data(_position, data):
	var my_item_index = get_index()
	var _my_item = Inventory.inventory[my_item_index]
	Inventory.swap_items(my_item_index, data.item_index)
	Inventory.set_item(my_item_index, data.item)
	Inventory.drag_data = null
