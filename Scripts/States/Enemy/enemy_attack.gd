extends State
class_name EnemyAttack

@export var actor : CharacterBody2D
@export var enemy_sprite : Sprite2D
@export var animation_player : AnimationPlayer

@export var damage : int
@export var attack_range : float
@onready var player := get_tree().current_scene.get_node("Player")
var attack_pos : Vector2

func Enter():
	if !animation_player.is_connected("animation_finished", _on_animation_finished):
		animation_player.animation_finished.connect(_on_animation_finished)
	attack_sequence()

func _on_animation_finished(_a):
	if (player.global_position - actor.global_position).length() < attack_range:
		player.get_node("TakeDamageHandler").hit(damage)
		attack_sequence()
	else:
		Transitioned.emit(self, "EnemyPursue")

func attack_sequence():
	animation_player.play("Attack")
