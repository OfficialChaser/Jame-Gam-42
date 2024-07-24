extends Node2D
class_name Wand

var locked_rotation := false

# Dealing with changing sprite
@onready var fb_sprite = $WandSprites/FBSprite
@onready var res_sprite = $WandSprites/RESSprite

@onready var fireball_wand = $StateMachine/FireballWand
@onready var restoration_wand = $StateMachine/RestorationWand

@onready var wand_sprite = $SpriteHolder/WandSprite
@onready var state_machine = $StateMachine

func _process(_delta):
	if GameManager.game_over:
		visible = false
		return

	_manage_rotation()
	_determine_sprite_texture()

func _determine_sprite_texture():
	if state_machine.current_state == fireball_wand:
		wand_sprite.texture = fb_sprite.texture
	elif state_machine.current_state == restoration_wand:
		wand_sprite.texture = res_sprite.texture

func _manage_rotation():
	if get_global_mouse_position().distance_to(get_parent().global_position) < 5:
		locked_rotation = true
		if rotation <= 3 * PI / 2 and rotation >= PI / 2:
			rotation = move_toward(rotation, PI, 0.2)
		else:
			rotation = move_toward(rotation, 0, 0.2)
	else:
		locked_rotation = false
		
	if rotation > 2 * PI:
		rotation -= 2 * PI
	if rotation < 0:
		rotation += 2 * PI
