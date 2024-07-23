extends Control

@onready var mana_bar = $ManaBar

func _process(_delta):
	mana_bar.value = GameManager.mana

func _on_mana_depletor_timeout():
	GameManager.decrease_mana(1)
