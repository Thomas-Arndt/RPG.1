extends GridContainer

signal recipe_changed(recipe)

const recipe_label = preload("res://UI/RecipeLabel.tscn")

export (Array, Resource) var recipe_list = []
var start_index: int = 0
var end_index: int = 4
var cursor_index: int = 0

func _ready():
	populate_display()

func update_cursor_index(change):
	if cursor_index + change < 0 and start_index > 0:
		start_index += change
		end_index += change
		cursor_index = 0
	elif cursor_index + change < 0 and start_index == 0:
		cursor_index = 0
	elif cursor_index + change > 4 and end_index < len(recipe_list) - 1:
		start_index += change
		end_index += change
		cursor_index = 4
	elif cursor_index + change > 4 and end_index >= len(recipe_list) - 1:
		cursor_index = 4
	else:
		cursor_index = clamp(cursor_index + change, 0, len(recipe_list) - 1)
	update_recipe_display()
		
func update_recipe_display():
	for index in get_child_count():
		var child = get_child(index)
		if len(recipe_list) - 1 >= index:
			child.text = recipe_list[start_index + index].name
			if not has_all_ingredients(recipe_list[start_index + index]):
				child.set("custom_colors/font_color", Color(1.0, 1.0, 1.0, 0.4))
			else:
				child.set("custom_colors/font_color", null)
	highlight_active_row()
	emit_signal("recipe_changed", recipe_list[start_index + cursor_index])

func highlight_active_row():
	var style = StyleBoxFlat.new()
	style.set_bg_color(Color(0.518, 0.493, 0.528, 1.0))
	for index in get_child_count():
		var child = get_child(index)
		if index == cursor_index:
			child.set("custom_styles/normal", style)
		else:
			child.set("custom_styles/normal", null)

func craft_item():
	var recipe = recipe_list[start_index + cursor_index]
	if has_all_ingredients(recipe):
		Inventory.change_muon_pearls(-recipe.pearl_cost)
		for item in recipe.recipe:
			var item_index = Inventory.get_item_index(item.item)
			if item_index >= 0:
				Inventory.consume_item(item_index, item.quantity)
		Inventory.pick_up_item(recipe.product, recipe.product_quantity)
		SignalBus.emit_signal("item_fabricated", recipe.product)
		SignalBus.emit_signal("TriggerFromItemFabricated", recipe.product)
	update_recipe_display()

func has_all_ingredients(recipe):
	if Inventory.muon_pearls < recipe.pearl_cost:
		return false
	for item in recipe.recipe:
		var index = Inventory.get_item_index(item.item)
		if index < 0:
			return false
		elif Inventory.inventory[index].quantity < item.quantity:
			return false
	return true
	
func add_recipe_to_list(recipe):
	recipe_list.append(recipe)
	update_recipe_display()

func populate_display():
	for recipe in recipe_list:
		var new_label = recipe_label.instance()
		new_label.text = recipe.name
		if not has_all_ingredients(recipe):
			new_label.set("custom_colors/font_color", Color(1.0, 1.0, 1.0, 0.4))
		else:
			new_label.set("custom_colors/font_color", null)
		add_child(new_label)
