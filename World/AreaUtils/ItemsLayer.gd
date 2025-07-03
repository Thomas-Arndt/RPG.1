extends YSort

const thrower = preload("res://Effects/MapEffects/ItemThrower.tscn")

func _ready():
	randomize()
	SignalBus.connect("drop_item", self, "_on_drop_item_signal")
	
func _on_drop_item_signal(loc, weighted_values, direction, distance, item_resource):
	if item_resource.name == "Muon Pearl" and not PlayerStats.muon_attunement:
		return
	var quantity = weighted_random(weighted_values)
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

func weighted_random(weighted_values: Array):

	var total_weight = 0.0
	for pair in weighted_values:
		total_weight += pair[1]

	var roll = randf() * total_weight
	var cumulative = 0.0

	for pair in weighted_values:
		cumulative += pair[1]
		if roll < cumulative:
			return pair[0]

	return weighted_values[-1][0] 
