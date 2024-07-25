extends CharacterBody2D

func _process(_delta):
	if GameManager.game_over:
		$AnimationPlayer.stop()
