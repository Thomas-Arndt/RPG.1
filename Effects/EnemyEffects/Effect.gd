extends AnimatedSprite

func _ready():
	connect("animation_finished", self, "_on_animation_finished")
	frame = 0
	play("animate")

func _on_animation_finished():
	#Inventory.drop_item_container(global_position, self.get_parent())
	queue_free()
