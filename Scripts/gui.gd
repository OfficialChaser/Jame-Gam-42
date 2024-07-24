extends Control

@onready var mana_bar = $ManaBar

@onready var spell_label = $SpellLabel
@onready var health_label = $HealthLabel
@onready var ammo_label = $AmmoLabel

@onready var ammo_anim_player = $AmmoLabel/AnimationPlayer
@onready var spell_anim_player = $SpellLabel/AnimationPlayer
@onready var health_anim_player = $HealthLabel/AnimationPlayer

@onready var player = get_tree().get_first_node_in_group("Player")

var ui_ammo := 15
var last_spell := GameManager.current_spell

var ui_health := 100

func _process(_delta):
	update_spell()
	mana_bar.value = GameManager.mana
	update_health()

func _on_mana_depletor_timeout():
	GameManager.increase_mana(1)

func update_ammo(ammo : int):
	if ui_ammo != ammo:
		ammo_anim_player.play("Pop")
	ui_ammo = ammo
	if GameManager.current_spell == "FIREBALL":
		ammo_label.text = "AMMO: " + str(ammo) + "/" + str(GameManager.mana/2-ammo)# maxAmmo
	else:	#reload needs to be reworked where you only gain as many bullets as you have mana (not always full mag)
		ammo_label.text = "AMMO: " + str(ammo) + "/" + str(GameManager.mana/5-ammo)# maxAmmo
	if ammo == 0:
		player.change_warning_label(true)
	else:
		player.change_warning_label(false)
	# If no mana, indicate that as well

func update_spell():
	if last_spell != GameManager.current_spell:
		spell_anim_player.play("Pop")
	spell_label.text = "SPELL: " + GameManager.current_spell
	last_spell = GameManager.current_spell

func update_health():
	var player_health = player.get_node("TakeDamageHandler").health
	if ui_health != player_health:
		print(player_health)
		health_anim_player.play("Damaged")
		ui_health = player_health
	health_label.text = "Health: " + str(ui_health)
	

func reloading_text():
	ammo_anim_player.play("Reloading")
