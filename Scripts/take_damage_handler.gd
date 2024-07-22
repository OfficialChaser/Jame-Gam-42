extends Node
class_name TakeDamageHandler

@export var health : int

func hit(damage : int):
	health -= damage

func _process(_delta):
	if health <= 0:
		get_parent().queue_free()
