extends State
class_name RestorationWand

@export var grid_highlight : Sprite2D

var ammo := 1
var reloading := false

func Enter():
	grid_highlight.visible = true
	GameManager.current_spell = "RESTORATION"

func end_reloading():
	reloading = false
	ammo = 1
