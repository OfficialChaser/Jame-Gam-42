extends Area2D

var parent_body : CharacterBody2D

var damage_effect

var queue_pushback := false
@export var speed : float
@export var damage : int

var movement : Vector2
func _ready():
	set_as_top_level(true)

func _physics_process(delta):
	movement = (Vector2.RIGHT * speed).rotated(rotation)
	position += movement * delta
	if queue_pushback:
		spawn_damage_effect(parent_body)


func _on_body_entered(body):
	if "Enemy" in body.name:
		parent_body = body
		body.hit(movement, rotation, damage)
		queue_pushback = true
	else:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func spawn_damage_effect(body : CharacterBody2D):
	var instance = damage_effect.instantiate()
	instance.get_node("Label").text = str(damage)
	body.add_child(instance)
