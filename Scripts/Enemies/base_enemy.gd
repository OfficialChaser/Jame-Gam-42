extends CharacterBody2D

@onready var take_damage_handler = $TakeDamageHandler

func _on_enemy_spawn_enable_damage():
	take_damage_handler.can_take_damage = true
