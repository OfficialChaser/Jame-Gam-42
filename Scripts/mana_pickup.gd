extends Area2D
class_name ManaPickup

var mana_effect = preload("res://Scenes/Mana/mana_effect.tscn")

var mana_amount := 10
var queue_deletion = false

var tile_position : Vector2i
@onready var game_tiles = get_tree().current_scene.get_node("GameTiles")

func _process(_delta):
	game_tiles.check_overlapping_tile(self)
	$Sprite2D/AnimationPlayer.play("Glint")
	if queue_deletion:
		delete()

func _on_body_entered(body):
	if body.name == "Player":
		GameManager.score += 1
		GameManager.mana += mana_amount
		queue_deletion = true
		
func delete():
	spawn_effect()
	queue_free()

func spawn_effect():
	var instance = mana_effect.instantiate()
	instance.position = global_position
	instance.mana_amount = mana_amount
	get_tree().current_scene.add_child(instance)

func _on_lifetime_timeout():
	queue_free()
