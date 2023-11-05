extends Node
class_name QuestItemReward

export var item: Resource
export var quantity: int = 1

func _ready():
	item.quantity = quantity
