extends Node
class_name DestroyHandler

var mana_pickup = preload("res://Scenes/Mana/mana_pickup.tscn")

@export var actor : CharacterBody2D
@export var animation_player : AnimationPlayer
@export var state_machine : StateMachine

func destroy_with_reward():
	# Disable ability to move or attack if state machine
	if state_machine:
		state_machine.enabled = false
	
	# Disable character body
	actor.get_node("CollisionShape2D").disabled = true

	# Play animation if there is one
	if animation_player:
		# Animation needs to call queue free
		animation_player.play("Death")
	else:
		spawn_mana()
		queue_free()

func spawn_mana():
	var instance = mana_pickup.instantiate()
	instance.global_position = actor.global_position
	get_tree().current_scene.add_child(instance)
