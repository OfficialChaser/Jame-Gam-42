extends Node
class_name TakeDamageHandler

enum Type {PLAYER, ENEMY}
@export var type : Type

@export var can_take_damage := false
@export var health : int

@export var destroy_handler : DestroyHandler
@export var hit_flash_player : AnimationPlayer


func hit(damage : int):
	if can_take_damage:
		match type:
			Type.PLAYER:
				pass
			Type.ENEMY:
				if hit_flash_player:
					hit_flash_player.play("Hit Flash")

		health -= damage

func _process(_delta):
	if health <= 0:
		match type:
			Type.PLAYER:
				get_tree().reload_current_scene()
			Type.ENEMY:
				destroy_handler.destroy_with_reward()
