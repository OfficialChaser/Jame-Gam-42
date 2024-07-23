extends State
class_name EnemySpawn

signal enable_damage

@export var actor : CharacterBody2D
@export var enemy_sprite : Sprite2D
@export var animation_player : AnimationPlayer

func Enter():
	animation_player.animation_finished.connect(_on_animation_finished)
	animation_player.play("Spawn")

func _on_animation_finished(_anim_name):
	enable_damage.emit()
	Transitioned.emit(self, "EnemyPursue")
