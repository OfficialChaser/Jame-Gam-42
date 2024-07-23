extends Node
class_name DestroyHandler

@export var actor : CharacterBody2D
@export var animation_player : AnimationPlayer

func destroy_with_reward():
	# Disable ability to move or attack if state machine
	
	# Play animation if there is one
	if animation_player:
		animation_player.play("Death")
	
	# Drop mana on current tile
	
	# Ensure animation is finished, queue free
