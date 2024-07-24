extends Control

@onready var mana_bar = $ManaBar
@onready var spell_label = $SpellLabel

@onready var ammo_label = $AmmoLabel
@onready var ammo_anim_player = $AmmoLabel/AnimationPlayer
@onready var spell_anim_player = $SpellLabel/AnimationPlayer
@onready var player = get_tree().get_first_node_in_group("Player")
var ui_ammo := 15
var last_spell

func _process(_delta):
	if last_spell != GameManager.current_spell:
		spell_anim_player.play("Pop")
	mana_bar.value = GameManager.mana
	spell_label.text = "SPELL: " + GameManager.current_spell
	last_spell = GameManager.current_spell

func _on_mana_depletor_timeout():
	GameManager.decrease_mana(-1) #increases mana by 1

func update_ammo(ammo : int):
	if ui_ammo != ammo:
		ammo_anim_player.play("Pop")
	ui_ammo = ammo
	if GameManager.current_spell == "FIREBALL":
		ammo_label.text = "AMMO: " + str(ammo) + "/" + str(GameManager.mana/2-ammo)# maxAmmo
	else:	#reload needs to be reworked where you only gain as many bullets as you have mana (not always full mag)
		ammo_label.text = "AMMO: " + str(ammo) + "/" + str(GameManager.mana/5-ammo)# maxAmmo
	GameManager.mana
	if ammo == 0:
		player.change_warning_label(true)
	else:
		player.change_warning_label(false)
	# If no mana, indicate that as well

func reloading_text():
	ammo_anim_player.play("Reloading")
