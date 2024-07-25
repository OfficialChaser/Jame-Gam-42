extends Control

@onready var start_button_label = $StartButton/StartButtonLabel
@onready var quit_button_label = $QuitButton/QuitButtonLabel


func _on_start_button_mouse_entered():
	var tween = create_tween()
	tween.tween_property(start_button_label, "scale", Vector2(1.2, 1.2), 0.1)



func _on_start_button_mouse_exited():
	var tween = create_tween()
	tween.tween_property(start_button_label, "scale", Vector2(1, 1), 0.1)



func _on_start_button_down():
	var tween = create_tween()
	tween.tween_property(start_button_label, "scale", Vector2(0.8, 0.8), 0.1)


func _on_start_button_up():
	var tween = create_tween()
	tween.tween_property(start_button_label, "scale", Vector2(1, 1), 0.2)
	await tween.finished
	get_tree().change_scene_to_file("res://Scenes/Main/main.tscn")


func _on_quit_button_mouse_entered():
	print("hi")
	var tween = create_tween()
	tween.tween_property(quit_button_label, "scale", Vector2(1.2, 1.2), 0.1)


func _on_quit_button_mouse_exited():
	var tween = create_tween()
	tween.tween_property(quit_button_label, "scale", Vector2(1, 1), 0.1)

	
func _on_quit_button_down():
	var tween = create_tween()
	tween.tween_property(quit_button_label, "scale", Vector2(0.8, 0.8), 0.1)


func _on_quit_button_up():
	var tween = create_tween()
	tween.tween_property(quit_button_label, "scale", Vector2(1, 1), 0.2)
	await tween.finished
	get_tree().quit()
