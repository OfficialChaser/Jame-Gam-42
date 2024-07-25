extends Timer



func _on_timeout():
	if !GameManager.game_over:
		GameManager.seconds_survived += 1
