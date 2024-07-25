extends State
class_name FireballWand

var bullet := preload("res://Scenes/Bullet/bullet.tscn")

@export var wand : Wand
@export var animation_player : AnimationPlayer

@export var bullet_marker : Marker2D
@export var grid_highlight : Sprite2D

@export var sfx : AudioStreamPlayer2D

@onready var gui = get_tree().current_scene.get_node("CanvasLayer").get_node("GUI")
var holding_shoot := false

@export var ammo := 15
var reloading := false

var rotating_back := false

func Enter():
	grid_highlight.visible = false
	GameManager.current_spell = "FIREBALL"

func Update(_delta):
	if !reloading:
		gui.update_ammo(ammo)
		if !wand.locked_rotation:
			if rotating_back:
				rotate_wand_back()
			else:
				wand.look_at(wand.get_global_mouse_position())
	else:
		gui.reloading_text()

	_check_autofire()
	_check_input()

func _check_input():
	var changed_spell := false
	# Switch wand state after right click
	if Input.is_action_just_pressed("right_click") and not reloading:
		Transitioned.emit(self, "RestorationWand")
		
	if Input.is_action_just_pressed("Reload"):
		reloading = true
		animation_player.play("reload_fireball")
	
	if Input.is_action_just_pressed("left_click"):
		holding_shoot = true

		if ammo <= 0:
			reloading = true
			animation_player.play("reload_fireball")

		elif !animation_player.is_playing():
			shoot()

	if Input.is_action_just_released("left_click"):
		holding_shoot = false
	
	if changed_spell and animation_player.is_playing():
		animation_player.stop()

func spawn_bullet():
	var instance = bullet.instantiate()
	instance.global_position = bullet_marker.global_position
	instance.rotation = wand.rotation
	add_child(instance)

# Shooting mechanic and spawning bullet
func shoot():
	if GameManager.mana > GameManager.shooting_cost and !reloading:
		sfx.play()
		ammo -= 1
		GameManager.decrease_mana(GameManager.shooting_cost)
		get_tree().current_scene.get_node("MainCamera").apply_shake(1, 6)
		animation_player.play("shoot")
		spawn_bullet()

# Allows player to shoot if they hold down
func _check_autofire():
	if holding_shoot and !animation_player.is_playing() and ammo > 0:
		shoot()

func rotate_wand_back():
	var prev_rotation = wand.rotation
	var rot 
	wand.look_at(round(wand.get_global_mouse_position()))
	rot = wand.rotation
	wand.rotation = prev_rotation
	wand.rotation = move_toward(wand.rotation, rot, 0.2)
	if wand.rotation == rot:
		rotating_back = false

func end_reloading():
	rotating_back = true
	reloading = false
	if (GameManager.mana > 0):
		if (GameManager.mana/2 > 15):
			ammo = 15
		else:
			ammo = GameManager.mana/2
