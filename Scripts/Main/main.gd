extends Node2D

@onready var game_tiles = %GameTiles
@onready var spawn_timer = $SpawnTimer

var base_enemy := preload("res://Scenes/Enemies/base_enemy.tscn")
var num = 1

func _on_spawn_timer_timeout():
	var instance = base_enemy.instantiate()
	var tile_position = game_tiles.find_random_tile()
	instance.global_position = game_tiles.map_to_local(tile_position)
	instance.name = "BaseEnemy" + str(num)
	num += 1
	add_child(instance)
