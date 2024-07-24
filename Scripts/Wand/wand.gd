extends Node2D
class_name Wand

enum WandStates {GUN, RESTORE}

var wand_state := 0

var bullet := preload("res://Scenes/Bullet/bullet.tscn")

@onready var gun_sprite = $SpriteHolder/WandSprite
@onready var bullet_marker = $BulletMarker
@onready var animation_player = $AnimationPlayer
@onready var grid_highlight = $GridHighlight
@onready var gui = get_tree().current_scene.get_node("CanvasLayer").get_node("GUI")

var holding_shoot := false

var fb_ammo := 5
var max_fb_ammo := 5
var reloading_fb := false

var res_ammo := 1
var reloading_res := false

var reloading : bool
var ammo : int

# Handling shooting input
func _input(event):
	if false:
		GameManager.current_spell = "RESTORATION"
		if event.is_action("left_click"):
			gui.update_ammo(ammo)
			restore_tiles()
			get_tree().current_scene.get_node("GameTiles").restore_tiles(get_global_mouse_position())

# Shooting mechanic and spawning bullet
func shoot():
	print("this shouldnt happen")
	if GameManager.mana > GameManager.shooting_cost and !reloading_fb and !reloading_res:
		fb_ammo -= 1
		gui.update_ammo(fb_ammo)
		GameManager.decrease_mana(GameManager.shooting_cost)
		get_tree().current_scene.get_node("MainCamera").apply_shake(1, 6)
		animation_player.play("shoot")
		spawn_bullet()
		
		if fb_ammo <= 0:
			reloading_fb = true
			animation_player.play("reload")

func restore_tiles():
	if GameManager.mana > GameManager.restoring_cost and !reloading:
		res_ammo -= 1
		gui.update_ammo(res_ammo)
		GameManager.decrease_mana(GameManager.restoring_cost)
		get_tree().current_scene.get_node("MainCamera").apply_shake(1, 6)
		animation_player.play("shoot")
		
		# Reloading
		reloading_res = true
		await get_tree().create_timer(0.2).timeout
		animation_player.play("reload")
	
func spawn_bullet():
	var instance = bullet.instantiate()
	instance.global_position = $BulletMarker.global_position
	instance.rotation = rotation
	add_child(instance)

# Allows player to shoot if they hold down
func _check_autofire():
	if holding_shoot and !animation_player.is_playing():
		shoot()

func end_reloading():
	if GameManager.current_spell == "FIREBALL":
		fb_ammo = max_fb_ammo
		gui.update_ammo(fb_ammo)
		reloading_fb = false
	elif GameManager.current_spell == "RESTORATION":
		res_ammo = 1
		gui.update_ammo(res_ammo)
		reloading_res = false
