extends Node2D
class_name Wand

enum WandStates {GUN, RESTORE}

var wand_state := 0

var bullet := preload("res://Scenes/Bullet/bullet.tscn")

@onready var gun_sprite = $SpriteHolder/WandSprite
@onready var bullet_marker = $BulletMarker
@onready var animation_player = $AnimationPlayer
@onready var grid_highlight = $GridHighlight

var holding_shoot := false

func _process(_delta):
	look_at(get_global_mouse_position())
	match wand_state:
		WandStates.GUN:
			grid_highlight.visible = false
			_check_rotation()
			_check_autofire()
		WandStates.RESTORE:
			grid_highlight.visible = true

# Handling shooting input
func _input(event):
	
	# Switch wand state after right click
	if event.is_action_pressed("right_click"):
		wand_state += 1
		if wand_state > 1:
			wand_state = 0
	
	# Do action depending on wand state
	match wand_state:
		WandStates.GUN:
			if event.is_action_pressed("left_click"):
				holding_shoot = true
				if !animation_player.is_playing():
					shoot()
			if event.is_action_released("left_click"):
				holding_shoot = false
		WandStates.RESTORE:
			if event.is_action("left_click"):
				restore_tiles()
				get_tree().current_scene.get_node("GameTiles").restore_tiles(get_global_mouse_position())

# Rotation of gun and hands function 
func _check_rotation():
	if get_global_mouse_position().x > get_parent().position.x:
		rotate_gun_and_player(false)
	elif get_global_mouse_position().x < get_parent().position.x:
		rotate_gun_and_player(true)

func rotate_gun_and_player(flip : bool):
	var player_sprite = get_parent().get_node("Sprite2D")
	if player_sprite:
		player_sprite.flip_h = flip
		gun_sprite.flip_v = flip
		if flip:
			bullet_marker.position.y = 0
		else:
			bullet_marker.position.y = 0

# Shooting mechanic and spawning bullet
func shoot():
	if GameManager.mana > GameManager.shooting_cost:
		GameManager.decrease_mana(GameManager.shooting_cost)
		get_tree().current_scene.get_node("MainCamera").apply_shake(1, 6)
		animation_player.play("shoot")
		spawn_bullet()

func restore_tiles():
	if GameManager.mana > GameManager.restoring_cost:
		GameManager.decrease_mana(GameManager.restoring_cost)
		get_tree().current_scene.get_node("MainCamera").apply_shake(1, 6)
		animation_player.play("shoot")
	
func spawn_bullet():
	var instance = bullet.instantiate()
	instance.global_position = $BulletMarker.global_position
	instance.rotation = rotation
	add_child(instance)

# Allows player to shoot if they hold down
func _check_autofire():
	if holding_shoot and !animation_player.is_playing():
		shoot()
