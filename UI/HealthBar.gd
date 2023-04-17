extends CanvasLayer

onready var fill_bar = $FillBar

func hide():
	fill_bar.visible = false

func show():
	fill_bar.visible = true
