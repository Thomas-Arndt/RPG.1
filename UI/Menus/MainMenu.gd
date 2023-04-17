extends CanvasLayer

onready var new_or_load : Node = $NewOrLoad
onready var nol_selector : Node = $NewOrLoad/NoLSelector
onready var lode : Node = $Load
onready var new : Node = $New
onready var new_keyboard : Node = $New/VBoxContainer/Keyboard
onready var new_keyboard_keys : Node = $New/VBoxContainer/Keyboard/VBoxContainer/GridContainer
onready var new_specials : Node = $New/VBoxContainer/Keyboard/VBoxContainer/HBoxContainer
onready var new_name : Node = $New/VBoxContainer/HBoxContainer/Label

enum states {
	NOL,
	NEW,
	LOAD,
}

enum directions {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

var state = states.NOL

var nol_cursor : int = 0
var new_cursor : int = 0
var load_cursor : int = 0

func _ready():
	apply_menu_change()
	highlight_active_row(nol_selector, nol_cursor)
	highlight_active_row(new_keyboard_keys, new_cursor)

func _input(event):
	if event.is_action("ui_up") and event.is_pressed() and not event.is_echo():
		move_cursor(directions.UP)
	if event.is_action("ui_down") and event.is_pressed() and not event.is_echo():
		move_cursor(directions.DOWN)
	if event.is_action("ui_left") and event.is_pressed() and not event.is_echo():
		move_cursor(directions.LEFT)
	if event.is_action("ui_right") and event.is_pressed() and not event.is_echo():
		move_cursor(directions.RIGHT)
	if event.is_action("quick_action_4") and event.is_pressed() and not event.is_echo():
		match state:
			states.NOL:
				apply_action(nol_selector.get_children()[nol_cursor].action)
			states.NEW:
				if new_cursor <= new_keyboard_keys.get_child_count() - 1:
					apply_action(new_keyboard_keys.get_child(new_cursor).action)
				else:
					apply_action(new_specials.get_child(new_cursor - new_keyboard_keys.get_child_count()).action)
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
		"keyboard_key_pressed":
			if new_cursor <= new_keyboard_keys.get_child_count() - 1:
				var new_char = new_keyboard_keys.get_child(new_cursor).value
				apply_character(new_char)
			else:
				var special_key = new_specials.get_child(new_cursor - new_keyboard_keys.get_child_count())
				apply_special_action(special_key)

func apply_character(character):
	var text = new_name.text
	text += character
	new_name.text = text

func apply_special_action(key):
	match key.value:
		"Space":
			apply_character(" ")
		"Delete":
			var text = new_name.text
			text.erase(len(text)-1, 1)
			new_name.text = text
		"Shift":
			new_keyboard.toggle_case()
		"OK":
			print(new_name.text)

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
			if state == states.NOL:
				update_active_cursor(-1)
			elif state == states.NEW:
				match new_cursor:
					29:
						update_active_cursor(-6)
					28:
						update_active_cursor(-7)
					27:
						update_active_cursor(-9)
					26:
						update_active_cursor(-12)
					_:
						update_active_cursor(-13)
		directions.DOWN:
			if state == states.NOL:
				update_active_cursor(1)
			elif state == states.NEW:
				update_active_cursor(13)
		directions.LEFT:
			if state == states.NEW:
				update_active_cursor(-1)
		directions.RIGHT:
			if state == states.NEW:
				update_active_cursor(1)

func update_active_cursor(change):
	match state:
		states.NOL:
			nol_cursor = clamp((nol_cursor + change), 0, nol_selector.get_child_count()-1)
		states.NEW:
			var total_keys = new_keyboard_keys.get_child_count() + new_specials.get_child_count()
			if (new_cursor + change >= 0) && (new_cursor + change < total_keys):
				new_cursor += change
			elif new_cursor + change >= total_keys:
				new_cursor = clamp(new_cursor + change, 0, total_keys-1)
		states.LOAD:
			pass
	apply_cursor_change()

func apply_cursor_change():
	clear_highlights()
	match state:
		states.NOL:
			highlight_active_row(nol_selector, nol_cursor)
		states.NEW:
			if new_cursor <= new_keyboard_keys.get_child_count() - 1:
				highlight_active_row(new_keyboard_keys, new_cursor)
			else:
				highlight_active_row(new_specials, new_cursor - new_keyboard_keys.get_child_count())
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

func clear_highlights():
	for index in new_keyboard_keys.get_child_count():
		var child = new_keyboard_keys.get_child(index)
		child.set("custom_styles/normal", null)
	for index in new_specials.get_child_count():
		var child = new_specials.get_child(index)
		child.set("custom_styles/normal", null)

func hide():
	new_or_load.visible = false
	new.visible = false
	lode.visible = false

func show():
	apply_menu_change()
