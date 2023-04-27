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
	show()
	Inventory.connect("gold_changed", self, "_on_Gold_changed")

func _on_Gold_changed(value):
	var gold = Inventory.gold
	number_display.text = str(gold)
	show()

func set_gold_icon(value):
	if value == 0:
		hide()
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
	margin_container.visible = true
	set_gold_icon(Inventory.gold)
