extends Node2D

@onready var game_tiles = %GameTiles

var skeleton_enemy := preload("res://Scenes/Enemies/skeleton_enemy.tscn")
var mana_pickup := preload("res://Scenes/Mana/mana_pickup.tscn")
var num = 1

func _on_enemy_spawn_timer_timeout():
	var instance = spawn_object(skeleton_enemy)
	instance.name = "Enemy" + str(num)
	num += 1
	add_child(instance)

func _on_mana_spawn_timer_timeout():
	var instance = mana_pickup.instantiate()
	var tile_position = game_tiles.find_random_tile()
	instance.global_position = game_tiles.map_to_local(tile_position)
	instance.name = "ManaPickup" + str(num)
	instance.tile_position = tile_position
	add_child(instance)

func spawn_object(object : PackedScene) -> Node2D:
	var instance = object.instantiate()
	var tile_position = game_tiles.find_random_tile()
	instance.global_position = game_tiles.map_to_local(tile_position)
	return instance
