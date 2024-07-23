extends Node
class_name TakeDamageHandler

var can_take_damage := false

@export var health : int

func hit(damage : int):
	if can_take_damage:
		health -= damage

func _process(_delta):
	if health <= 0:
		get_parent().queue_free()
