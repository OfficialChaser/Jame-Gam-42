extends Camera2D
class_name MainCamera

@export_range(0, 0.2) var offset_factor : float

var initial_offset = offset

var random_strength : float
var shake_fade : float

var rng = RandomNumberGenerator.new()

var shake_strength := 0.0

func _input(event):
	pass
	#if event is InputEventMouseMotion:
		#var target = event.position * 0.25
		#position = target.normalized() * (target.length()) * offset_factor

func _process(delta):
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		offset = random_offset() + initial_offset


func apply_shake(strength: float, fade : float):
	shake_strength = strength
	shake_fade = fade

func random_offset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
