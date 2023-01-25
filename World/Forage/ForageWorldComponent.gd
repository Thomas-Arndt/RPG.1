extends StaticBody2D

export (Resource) var forage_item
export (float) var respawn_time = 30

onready var sprite = $Sprite
onready var shadow_sprite = $ShadowSprite
onready var interaction_zone = $InteractionZone
onready var collision_shape = $CollisionShape2D
onready var timer = $Timer

func _ready():
	assert(forage_item)
	sprite.texture = forage_item.texture
	shadow_sprite.visible = true
	collision_shape.set_deferred("disabled", false)
	interaction_zone.collision_shape.set_deferred("disabled", false)
	interaction_zone.connect("interaction_finished", self, "_on_interaction_finished")

func _on_interaction_finished(node):
	sprite.texture = null
	shadow_sprite.visible = false
	collision_shape.set_deferred("disabled", true)
	interaction_zone.collision_shape.set_deferred("disabled", true)
	timer.start(respawn_time)

func _on_Timer_timeout():
	sprite.texture = forage_item.texture
	shadow_sprite.visible = true
	collision_shape.set_deferred("disabled", false)
	interaction_zone.collision_shape.set_deferred("disabled", false)
