extends Sprite2D

var locked_position := false

func _ready():
	set_as_top_level(true)

func _process(_delta):
	if not locked_position:
		global_position = snapped(
			get_global_mouse_position() - Vector2(6, 6), 
			Vector2(12,12)
		) + Vector2(6, 6)
	
func Repair():
	locked_position = true
	$AnimationPlayer.play("Repair")

func unlock_movement():
	locked_position = false
