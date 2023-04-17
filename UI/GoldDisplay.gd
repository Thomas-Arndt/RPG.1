extends CanvasLayer

onready var margin_container = $MarginContainer
onready var NumberDisplay = $MarginContainer/HBoxContainer/Label

func _ready():
	Inventory.connect("gold_changed", self, "_on_Gold_changed")

func _on_Gold_changed(value):
	NumberDisplay.text = str(value)

func hide():
	margin_container.visible = false

func show():
	margin_container.visible = true
