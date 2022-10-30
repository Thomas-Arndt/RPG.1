extends CanvasLayer

onready var background = $BackpackBackground
onready var inventory = $InventoryDisplay


func _ready():
	background.visible = false
	inventory.visible = false


func toggle_backpack():
	background.visible = !background.visible
	inventory.visible = !inventory.visible

