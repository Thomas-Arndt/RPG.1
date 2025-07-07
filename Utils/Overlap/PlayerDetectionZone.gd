extends Area2D

signal player_detected(player)
signal player_exited(player)

onready var collision_shape = $CollisionShape2D

var player = null
var detected_body = null

func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]

func can_see_player():
	return detected_body != null

func set_collision_shape(shape_2d):
	collision_shape.shape = shape_2d

func _on_PlayerDetectionZone_body_entered(body):
	if body == player:
		detected_body = body
		emit_signal("player_detected", body)

func _on_PlayerDetectionZone_body_exited(body):
	if body == player:
		detected_body = null
		emit_signal("player_exited", body)
