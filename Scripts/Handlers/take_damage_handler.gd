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
				if hit_flash_player:
					var camera = get_tree().get_first_node_in_group("main_camera")
					camera.apply_shake(2, 7)
					GameManager.slow_time()
					hit_flash_player.play("Hit Flash")
			Type.ENEMY:
				if hit_flash_player:
					GameManager.slow_time()
					hit_flash_player.play("Hit Flash")

		health -= damage

func _process(_delta):
	if health <= 0:
		match type:
			Type.PLAYER:
				get_tree().reload_current_scene()
			Type.ENEMY:
				destroy_handler.destroy_with_reward()
