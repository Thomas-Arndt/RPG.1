extends YSort

func _ready():
	SignalBus.connect("drop_item", self, "_on_drop_item_signal")
	
func _on_drop_item_signal(direction, distance):
	print(dro)
