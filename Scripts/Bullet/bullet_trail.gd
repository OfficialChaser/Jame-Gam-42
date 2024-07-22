extends Line2D

@onready var bullet = get_parent()
@export var length : int

func _ready():
	set_as_top_level(true)

func _process(_delta):
	global_position = Vector2.ZERO
	add_point(bullet.global_position)
	while get_point_count() > length:
		remove_point(0)

