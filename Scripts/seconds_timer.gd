extends Timer



func _on_timeout():
	GameManager.seconds_survived += 1
