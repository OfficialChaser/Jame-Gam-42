extends Sprite2D


func _ready():
	set_as_top_level(true)

func _process(_delta):
	global_position = snapped(
		get_global_mouse_position() - Vector2(6, 6), 
		Vector2(12,12)
	) + Vector2(6, 6)
	
func Repair():
	$AnimationPlayer.play("Repair")
