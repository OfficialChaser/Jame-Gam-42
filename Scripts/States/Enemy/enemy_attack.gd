extends State
class_name EnemyAttack

# References
@export var actor : CharacterBody2D
@export var enemy_sprite : Sprite2D
@export var animation_player : AnimationPlayer

# Stat vars
@export var damage : int
@export var attack_range : float

@onready var player := get_tree().current_scene.get_node("Player")

func Enter():
	# Connecting signal to function if not already
	if !animation_player.is_connected("animation_finished", _on_animation_finished):
		animation_player.animation_finished.connect(_on_animation_finished)
	
	# Starting the attack sequence
	attack_sequence()

func _on_animation_finished(_anim_name):
	# Checking if enemy is close enough to attack again
	if player:
		if (player.global_position - actor.global_position).length() < attack_range:
			player.get_node("TakeDamageHandler").hit(damage)
			attack_sequence()
	
		# If not, return to pursuing
		else:
			Transitioned.emit(self, "EnemyPursue")

func attack_sequence():
	animation_player.play("Attack")
