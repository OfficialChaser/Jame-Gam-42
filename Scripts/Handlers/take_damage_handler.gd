extends Node
class_name TakeDamageHandler

var damage_effect = preload("res://Scenes/Effects/damage_effect.tscn")
var hit_particles = preload("res://Scenes/Effects/hit_particles.tscn")
var queue_damage_effect := false

enum Type {PLAYER, ENEMY}
@export var type : Type

@export var actor : CharacterBody2D

@export var can_take_damage := false
@export var health : int:
	set (new_value):
		health = clamp(new_value, 0, 100)

@export var destroy_handler : DestroyHandler
@export var hit_flash_player : AnimationPlayer

@export var particle_color : Color
var particle_rotation : float


func hit(damage : int, particle_rot = -1000.0):
	if can_take_damage:
		match type:
			Type.PLAYER:
				if hit_flash_player:
					var camera = get_tree().get_first_node_in_group("main_camera")
					camera.apply_shake(2, 7)
					GameManager.slow_time()
					hit_flash_player.play("Hit Flash")
			Type.ENEMY:
				queue_damage_effect = true
				if hit_flash_player:
					GameManager.slow_time()
					hit_flash_player.play("Hit Flash")

				if particle_rot != -1000.0:
					particle_rotation = particle_rot

		health -= damage

func _process(_delta):
	match type:
		Type.PLAYER:
			pass
		Type.ENEMY:
			if queue_damage_effect and Engine.time_scale > 0.5:
				spawn_damage_effect(particle_rotation)
	if health <= 0:
		match type:
			Type.PLAYER:
				destroy_handler.destroy_player("Killed")
			Type.ENEMY:
				destroy_handler.destroy_with_reward()

func spawn_damage_effect(rot = 0.0):
	queue_damage_effect = false
	var instance = damage_effect.instantiate()
	instance.global_position = actor.global_position
	instance.set_as_top_level(true)
	get_parent().add_child(instance)

	if particle_color:
		var instance2 = hit_particles.instantiate()
		
		instance2.global_position = actor.global_position
		instance2.rotation = particle_rotation
		
		instance2.set_as_top_level(true)
		
		instance2.emitting = true
		instance2.color = particle_color
		
		get_parent().add_child(instance2)
