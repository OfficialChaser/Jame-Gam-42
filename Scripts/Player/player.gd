extends CharacterBody2D
class_name Player

@onready var wand = $Wand
@onready var player_sprite = $Sprite2D

var direction : Vector2
@export var speed : float
@export var acc : float
@export var dec : float

var past_global_pos : Vector2
var stationary : bool

func _physics_process(_delta):
	#print($TakeDamageHandler.health)
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = lerp(velocity, direction * speed, 0.1)
	
	past_global_pos = global_position
	move_and_slide()
	check_global_position()
func _process(_delta):
	_handle_animations()

func _handle_animations():
	if direction != Vector2.ZERO and !stationary:
		player_sprite.get_node("AnimationPlayer").play("Run")
	else:
		if player_sprite.rotation != 0:
			player_sprite.rotation = lerp(player_sprite.rotation, 0.0, 0.2)
		player_sprite.get_node("AnimationPlayer").play("Idle")

func check_global_position():
	if round(past_global_pos) == round(global_position):
		stationary = true
	else:
		stationary = false
