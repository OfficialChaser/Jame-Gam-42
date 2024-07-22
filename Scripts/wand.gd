extends Node2D

var bullet := preload("res://Scenes/bullet.tscn")

@onready var gun_sprite = $SpriteHolder/GunSprite
@onready var hands_sprite = $SpriteHolder/HandsSprite
@onready var bullet_marker = $BulletMarker
@onready var animation_player = $AnimationPlayer

var holding_shoot := false

func _process(_delta):
	look_at(get_global_mouse_position())
	_check_rotation()
	_check_autofire()

# Handling shooting input
func _input(event):
	if event.is_action_pressed("left_click") and !animation_player.is_playing():
		shoot()
		holding_shoot = true
	if event.is_action_released("left_click"):
		holding_shoot = false

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
			bullet_marker.position.y = 6
			hands_sprite.position.y = -6
		else:
			bullet_marker.position.y = 0
			hands_sprite.position.y = 0

# Shooting mechanic and spawning bullet
func shoot():
	get_tree().current_scene.get_node("MainCamera").apply_shake(1, 2)
	animation_player.play("shoot")
	spawn_bullet()

func spawn_bullet():
	var instance = bullet.instantiate()
	instance.global_position = $BulletMarker.global_position
	instance.rotation = rotation
	add_child(instance)

# Allows player to shoot if they hold down
func _check_autofire():
	if holding_shoot and !animation_player.is_playing():
		shoot()
