extends Node

var score := 0
var mana := 100:
	set (new_value):
		mana = clamp(new_value, 0, 100)

var shooting_cost := 2
var restoring_cost := 3
var mana_pickup_amt := 5

var current_spell := "FIREBALL"

var place_of_death : Vector2
var game_over := false

func _process(_delta):
	if mana <= 5:
		mana_pickup_amt = 20
	elif mana <= 35:
		mana_pickup_amt = 10
	else:
		mana_pickup_amt = 5

func increase_mana(amt : int):
	mana += amt

func decrease_mana(amt : int):
	mana -= amt

func reset_stats():
	score = 0
	mana = 100
	shooting_cost = 2
	restoring_cost = 5

func slow_time():
	Engine.time_scale = 0.05
	await get_tree().create_timer(0.018).timeout
	Engine.time_scale = 1
