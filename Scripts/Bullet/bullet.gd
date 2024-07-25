extends Area2D

var parent_body : CharacterBody2D

var wall_particles := preload("res://Scenes/Effects/wall_particles.tscn")
var sfx := preload("res://Scenes/bullet_sfx.tscn")

var damage_effect
@export var speed : float
@export var damage : int

var movement : Vector2
func _ready():
	set_as_top_level(true)

func _physics_process(delta):
	movement = (Vector2.RIGHT * speed).rotated(rotation)
	position += movement * delta
	


func _on_body_entered(body):
	if body.is_in_group("enemies"):
		parent_body = body
		body.get_node("TakeDamageHandler").hit(damage, rotation)
		queue_free()
	else:
		spawn_wall_particles()
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func spawn_wall_particles():
	var instance = wall_particles.instantiate()
	
	instance.global_position = global_position
	instance.rotation = rotation + PI
	
	instance.set_as_top_level(true)
	
	instance.emitting = true
	get_parent().add_child(instance)
	
	var instance2 = sfx.instantiate()
	instance2.global_position = global_position
	get_tree().current_scene.add_child(instance2)
	instance2.play()
	
