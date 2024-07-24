extends Area2D
class_name ManaPickup

var mana_amount := 5

var tile_position : Vector2i
@onready var game_tiles = get_tree().current_scene.get_node("GameTiles")

func _process(_delta):
	game_tiles.check_overlapping_tile(self)
	$Sprite2D/AnimationPlayer.play("Glint")

func _on_body_entered(body):
	if body.name == "Player":
		GameManager.score += 1
		GameManager.mana += mana_amount
		queue_free()


func _on_lifetime_timeout():
	queue_free()
