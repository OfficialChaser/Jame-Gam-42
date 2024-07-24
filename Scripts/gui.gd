extends Control

@onready var mana_bar = $ManaBar
@onready var spell_label = $SpellLabel
@onready var ammo_label = $AmmoLabel

func _process(_delta):
	mana_bar.value = GameManager.mana
	spell_label.text = "SPELL: " + GameManager.current_spell

func _on_mana_depletor_timeout():
	GameManager.decrease_mana(1)

func update_ammo(ammo : int):
	ammo_label.text = "Ammo: " + str(ammo)
