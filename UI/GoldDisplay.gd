extends CanvasLayer

var gold_1 = preload("res://Assets/Sprites/Gold/1.png")
var gold_2 = preload("res://Assets/Sprites/Gold/2.png")
var gold_3 = preload("res://Assets/Sprites/Gold/3.png")
var gold_4 = preload("res://Assets/Sprites/Gold/4.png")
var gold_5 = preload("res://Assets/Sprites/Gold/5.png")
var gold_6 = preload("res://Assets/Sprites/Gold/10.png")

onready var margin_container = $MarginContainer
onready var number_display = $MarginContainer/HBoxContainer/Label
onready var texture : Node = $MarginContainer/HBoxContainer/TextureRect

func _ready():
	_on_Gold_changed(Inventory.gold)
	Inventory.connect("gold_changed", self, "_on_Gold_changed")

func _on_Gold_changed(value):
	print(value)
	var gold = Inventory.gold
	print(gold)
	number_display.text = str(gold)
	if gold > 0:
		show()
	else:
		hide()

func set_gold_icon(value):
	if value <= 0:
		return
	if value - 500 > 0:
		texture.texture = gold_6
		return
	if value - 250 > 0:
		texture.texture = gold_5
		return
	if value - 100 > 0:
		texture.texture = gold_4
		return
	if value - 25 > 0:
		texture.texture = gold_3
		return
	if value - 10 > 0:
		texture.texture = gold_2
		return
	if value - 1 > 0:
		texture.texture = gold_1
		return

func hide():
	margin_container.visible = false

func show():
	if Inventory.gold > 0:
		margin_container.visible = true
		set_gold_icon(Inventory.gold)
