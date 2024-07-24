extends Node2D
class_name Wand

var locked_rotation := false

func _process(_delta):
	if get_global_mouse_position().distance_to(get_parent().global_position) < 5:
		locked_rotation = true
		if rotation <= 3 * PI / 2 and rotation >= PI / 2:
			rotation = move_toward(rotation, PI, 0.2)
		else:
			rotation = move_toward(rotation, 0, 0.2)
	else:
		locked_rotation = false
		
	if rotation > 2 * PI:
		rotation -= 2 * PI
	if rotation < 0:
		rotation += 2 * PI
