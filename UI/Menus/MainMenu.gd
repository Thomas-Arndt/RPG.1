extends CanvasLayer

const NOL_LIST_SIZE = 2

onready var new_or_load : Node = $NewOrLoad
onready var nol_selector : Node = $NewOrLoad/NoLSelector
onready var lode : Node = $Load
onready var new : Node = $New

enum states {
	NOL,
	NEW,
	LOAD,
}

enum directions {
	UP,
	DOWN
}

var state = states.NOL

var nol_cursor : int = 0
var new_cursor : int = 0
var load_cursor : int = 0

func _ready():
	apply_menu_change()
	highlight_active_row(nol_selector, nol_cursor)

func _input(event):
	if event.is_action("ui_up") and event.is_pressed() and not event.is_echo():
		move_cursor(directions.UP)
	if event.is_action("ui_down") and event.is_pressed() and not event.is_echo():
		move_cursor(directions.DOWN)
	if event.is_action("quick_action_4") and event.is_pressed() and not event.is_echo():
		match state:
			states.NOL:
				apply_action(nol_selector.get_children()[nol_cursor].action)
			states.NEW:
				apply_action("nol_menu")
			states.LOAD:
				apply_action("nol_menu")

func apply_action(action):
	match action:
		"nol_menu":
			change_menu(states.NOL)
		"new_menu":
			change_menu(states.NEW)
		"load_menu":
			change_menu(states.LOAD)

func change_menu(menu):
	state = menu
	apply_menu_change()

func apply_menu_change():
	hide()
	match state:
		states.NOL:
			new_or_load.visible = true
		states.NEW:
			new.visible = true
		states.LOAD:
			lode.visible = true

func move_cursor(direction):
	match direction:
		directions.UP:
			update_active_cursor(-1)
		directions.DOWN:
			update_active_cursor(1)

func update_active_cursor(change):
	match state:
		states.NOL:
			nol_cursor = clamp((nol_cursor + change), 0, NOL_LIST_SIZE-1)
		states.NEW:
			pass
		states.LOAD:
			pass
	apply_cursor_change()

func apply_cursor_change():
	match state:
		states.NOL:
			highlight_active_row(nol_selector, nol_cursor)
		states.NEW:
			pass
		states.LOAD:
			pass

func highlight_active_row(menu_node, cursor):
	var style = StyleBoxFlat.new()
	style.set_bg_color(Color(0.518, 0.493, 0.528, 1.0))
	for index in menu_node.get_child_count():
		var child = menu_node.get_child(index)
		if index == cursor:
			child.set("custom_styles/normal", style)
		else:
			child.set("custom_styles/normal", null)

func hide():
	new_or_load.visible = false
	new.visible = false
	lode.visible = false

func show():
	apply_menu_change()
