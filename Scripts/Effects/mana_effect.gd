extends RigidBody2D

@onready var label = $Label
var mana_amount := 5

func _ready():
	linear_velocity.x = randf_range(-20, 120)
	linear_velocity.y = randf_range(-200, -220)
	
	var tween = get_tree().create_tween()
	tween.tween_property(
		label, "scale", 
		Vector2.ZERO, 0.5
	).set_trans(Tween.TRANS_LINEAR).set_ease(tween.EASE_OUT)

func _process(_delta):
	label.text = "+" + str(mana_amount)
