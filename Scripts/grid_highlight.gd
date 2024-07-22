extends Sprite2D

func _ready():
	set_as_top_level(true)

func _process(_delta):
	global_position = snapped(
		get_global_mouse_position() - Vector2(8, 8), 
		Vector2(16,16)
	) + Vector2(8, 8)
