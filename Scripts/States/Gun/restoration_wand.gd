extends State
class_name RestorationWand

@export var wand : Wand

@export var animation_player : AnimationPlayer
@export var grid_highlight : Sprite2D
@onready var gui = get_tree().current_scene.get_node("CanvasLayer").get_node("GUI")

var ammo := 1
var reloading := false

var rotating_back := false

func Enter():
	grid_highlight.visible = true
	GameManager.current_spell = "REPAIR"

func Update(_delta):
	if !reloading:
		if !wand.locked_rotation:
			if rotating_back:
				var prev_rotation = wand.rotation
				var rot 
				wand.look_at(round(wand.get_global_mouse_position()))
				rot = wand.rotation
				wand.rotation = prev_rotation
				wand.rotation = move_toward(wand.rotation, rot, 0.2)
				if wand.rotation == rot:
					print("test")
					rotating_back = false
			else:
				wand.look_at(wand.get_global_mouse_position())
		gui.update_ammo(ammo)
	else:
		gui.reloading_text()
	check_input()

func check_input():
	# Switch wand state after right click
	if Input.is_action_just_pressed("right_click") and not reloading:
		Transitioned.emit(self, "FireballWand")
		
	if Input.is_action_just_pressed("Reload"):
		reloading = true
		animation_player.play("reload_restoration")
		
	if Input.is_action_just_pressed("left_click"):
		if ammo == 1:
			restore_tiles()
		else:
			# Reloading
			reloading = true
			animation_player.play("reload_restoration")

func restore_tiles():
	if GameManager.mana > GameManager.restoring_cost and !reloading:
		var tiles = get_tree().current_scene.get_node("GameTiles")
		tiles.restore_tiles(wand.get_global_mouse_position())
		
		ammo -= 1
		
		GameManager.decrease_mana(GameManager.restoring_cost)
		
		get_tree().current_scene.get_node("MainCamera").apply_shake(1, 6)
		animation_player.play("shoot")
		grid_highlight.Repair()

func end_reloading():
	rotating_back = true
	grid_highlight.visible = true
	reloading = false
	ammo = 1
