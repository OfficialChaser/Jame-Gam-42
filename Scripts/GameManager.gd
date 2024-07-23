extends Node

var score := 0
var mana := 100
var shooting_cost := 2
var restoring_cost := 5

func _process(_delta):
	pass

func decrease_mana(amt : int):
	mana -= amt

func reset_stats():
	score = 0
	mana = 100
	shooting_cost = 2
	restoring_cost = 5
