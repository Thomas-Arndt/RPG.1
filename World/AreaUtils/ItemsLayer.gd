extends YSort

const thrower = preload("res://Effects/MapEffects/ItemThrower.tscn")

func _ready():
	randomize()
	SignalBus.connect("drop_item", self, "_on_drop_item_signal")
	
func _on_drop_item_signal(loc, quantity, direction, distance, item_resource):
	if quantity < 1:
		return
	elif quantity == 1:
		if direction == null:
			direction = randi() % 360
		drop_thrower(loc, direction, distance, item_resource)
	elif quantity > 1:
		var rotational_diff = 360/quantity
		if direction == null:
			direction = randi() % 360
		for i in quantity:
			drop_thrower(loc, direction, distance, item_resource)
			direction += rotational_diff
			if direction > 360:
				direction -= 360

func drop_thrower(loc, direction, distance, item_resource):
	var new_thrower = thrower.instance()
	new_thrower.global_position = loc
	new_thrower.item_resource = item_resource
	get_parent().add_child(new_thrower)
	new_thrower.throw_item(direction, distance)
