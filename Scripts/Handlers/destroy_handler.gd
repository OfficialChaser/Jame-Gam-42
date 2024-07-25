extends Node
class_name DestroyHandler

var mana_pickup = preload("res://Scenes/Mana/mana_pickup.tscn")

@export var actor : CharacterBody2D
@export var animation_player : AnimationPlayer
@export var state_machine : StateMachine
@export var mana_amount : int
@export var death_sfx : AudioStreamPlayer2D

var played_death_sfx := false
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
		actor.z_index = 0
	
	else:
		spawn_mana()
		queue_free()

func destroy_player(way : String):
	if !death_sfx.is_playing() and !played_death_sfx:
		played_death_sfx = true
		death_sfx.global_position = actor.global_position
		death_sfx.play()
	actor.get_node("CollisionShape2D").disabled = true
	actor.can_move = false
	GameManager.game_over = true
	var camera = get_tree().get_first_node_in_group("main_camera")
	camera.zoom_in_on_player()
	
	if way.to_lower() == "falling":
		actor.global_position = GameManager.place_of_death
		if animation_player:
			# Animation needs to call queue free
			animation_player.play("Fall")
			# queue game over in animation
	elif way.to_lower() == "killed":
		if animation_player:
			# Animation needs to call queue free
			animation_player.play("Die")
			# queue game over in animation

func spawn_mana():
	var instance = mana_pickup.instantiate()
	instance.global_position = actor.global_position
	instance.mana_amount = mana_amount
	get_tree().current_scene.add_child(instance)
	
func update_enemy_kill_count():
	GameManager.enemies_killed += 1
