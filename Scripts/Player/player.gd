extends CharacterBody2D
class_name Player

var can_move := true

@onready var wand = $Wand
@onready var player_sprite = $Sprite2D
@onready var destroy_handler = $DestroyHandler

var direction : Vector2
@export var speed : float
@export var acc : float
@export var dec : float

var past_global_pos : Vector2
var stationary : bool

func _physics_process(_delta):
	if can_move:
		direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = lerp(velocity, direction * speed, 0.1)
		
		past_global_pos = global_position
		move_and_slide()
		check_global_position()
func _process(_delta):
	if can_move:
		_handle_animations()

func _handle_animations():
	if direction != Vector2.ZERO and !stationary:
		player_sprite.get_node("AnimationPlayer").play("Run")
	else:
		if player_sprite.rotation != 0:
			player_sprite.rotation = lerp(player_sprite.rotation, 0.0, 0.2)
		player_sprite.get_node("AnimationPlayer").play("Idle")
	
	if global_position.x > get_global_mouse_position().x:
		player_sprite.flip_h = true
	elif global_position.x < get_global_mouse_position().x:
		player_sprite.flip_h = false

func check_global_position():
	if round(past_global_pos) == round(global_position):
		stationary = true
	else:
		stationary = false

func change_warning_label(status : bool):
	$WarningLabel.visible = status

func die_by_falling():
	GameManager.game_over = true
	destroy_handler.destroy_player("Falling")
