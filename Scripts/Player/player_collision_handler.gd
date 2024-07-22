extends Area2D
class_name PlayerCollisionHandler

@export var actor : CharacterBody2D
@onready var tiles = get_tree().current_scene.get_node("GameTiles")

func _process(_delta):
	tiles.check_overlapping_tile(actor)
