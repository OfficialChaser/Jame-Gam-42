extends State
class_name FireballWand

var bullet := preload("res://Scenes/Bullet/bullet.tscn")

@export var wand : Wand
@export var animation_player : AnimationPlayer

@export var bullet_marker : Marker2D
@export var grid_highlight : Sprite2D

@onready var gui = get_tree().current_scene.get_node("CanvasLayer").get_node("GUI")

var holding_shoot := false

var ammo := 5
var reloading := false

func Enter():
	grid_highlight.visible = false
	GameManager.current_spell = "FIREBALL"

func Update(_delta):
	wand.look_at(wand.get_global_mouse_position())
	_check_autofire()
	gui.update_ammo(ammo)

func _input(event):
	var changed_spell := false
	# Switch wand state after right click
	if event.is_action_pressed("right_click") and not reloading:
		Transitioned.emit(self, "RestorationWand")

	if event.is_action_pressed("left_click"):
		holding_shoot = true
		
		if ammo <= 0:
			reloading = true
			animation_player.play("reload_fireball")

		elif !animation_player.is_playing():
			shoot()

	if event.is_action_released("left_click"):
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
		ammo -= 1
		GameManager.decrease_mana(GameManager.shooting_cost)
		get_tree().current_scene.get_node("MainCamera").apply_shake(1, 6)
		animation_player.play("shoot")
		spawn_bullet()

# Allows player to shoot if they hold down
func _check_autofire():
	if holding_shoot and !animation_player.is_playing() and ammo > 0:
		shoot()

func end_reloading():
	reloading = false
	ammo = 5
