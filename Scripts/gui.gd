extends Control

@onready var mana_bar = $ManaBar
@onready var spell_label = $SpellLabel

@onready var ammo_label = $AmmoLabel
@onready var ammo_anim_player = $AmmoLabel/AnimationPlayer
@onready var player = get_tree().get_first_node_in_group("Player")
var ui_ammo := 15

func _process(_delta):
	mana_bar.value = GameManager.mana
	spell_label.text = "SPELL: " + GameManager.current_spell

func _on_mana_depletor_timeout():
	GameManager.decrease_mana(1)

func update_ammo(ammo : int):
	if ui_ammo != ammo:
		ammo_anim_player.play("Pop")
	ui_ammo = ammo
	ammo_label.text = "AMMO: " + str(ammo)
	
	if ammo == 0:
		player.change_warning_label(true)
	else:
		player.change_warning_label(false)
	# If no mana, indicate that as well

func reloading_text():
	ammo_anim_player.play("Reloading")
