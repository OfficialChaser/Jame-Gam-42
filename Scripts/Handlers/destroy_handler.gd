extends Node
class_name DestroyHandler

var mana_pickup = preload("res://Scenes/Mana/mana_pickup.tscn")

@export var actor : CharacterBody2D
@export var animation_player : AnimationPlayer
@export var state_machine : StateMachine
@export var mana_amount : int

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

func destroy_player(way : String):
	actor.get_node("CollisionShape2D").disabled = true
	actor.can_move = false
	actor.global_position = GameManager.place_of_death
	
	if way.to_lower() == "falling":
		if animation_player:
			# Animation needs to call queue free
			animation_player.play("Fall")
			# queue game over in animation

func spawn_mana():
	var instance = mana_pickup.instantiate()
	instance.global_position = actor.global_position
	instance.mana_amount = mana_amount
	get_tree().current_scene.add_child(instance)
