extends Control

onready var recipe_display = $RecipeDisplay
onready var recipe_list = $RecipeList

func _ready():
	recipe_list.connect("recipe_changed", self, "_on_Recipe_List_recipe_changed")
	recipe_display.text = get_display_text(recipe_list.recipe_list[0])

func _on_Recipe_List_recipe_changed(recipe):
	recipe_display.text = get_display_text(recipe)

func get_display_text(recipe):
	var text: String
	for ingredient in recipe.recipe:
		text += ingredient.item.name + " x " + str(ingredient.quantity) + " \n"
	text += "Muon Pearl x " + str(recipe.pearl_cost) + "(" + str(Inventory.muon_pearls) + ") \n"
	return text
