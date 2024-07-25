extends Control

@onready var start_button_label = $StartButton/StartButtonLabel


func _on_start_button_mouse_entered():
	var tween = create_tween()
	tween.tween_property(start_button_label, "scale", Vector2(1.2, 1.2), 0.1)



func _on_start_button_mouse_exited():
	print("ee")
	var tween = create_tween()
	tween.tween_property(start_button_label, "scale", Vector2(1, 1), 0.1)


func _on_start_button_pressed():
	var tween = create_tween()
	tween.tween_property(start_button_label, "scale", Vector2(0.8, 0.8), 0.2)
	tween.tween_property(start_button_label, "scale", Vector2(1, 1), 0.2)
	await tween.finished
	get_tree().change_scene_to_file("res://Scenes/Main/main.tscn")
