extends Control

var mana_effect = preload("res://Scenes/Mana/mana_effect.tscn")

@onready var mana_bar = $ManaBar

@onready var spell_label = $SpellLabel
@onready var health_label = $HealthLabel
@onready var ammo_label = $AmmoLabel
@onready var mana_label = $ManaLabel

@onready var ammo_anim_player = $AmmoLabel/AnimationPlayer
@onready var spell_anim_player = $SpellLabel/AnimationPlayer
@onready var health_anim_player = $HealthLabel/AnimationPlayer
@onready var mana_animation_player = $ManaLabel/AnimationPlayer

@onready var player = get_tree().get_first_node_in_group("Player")

var ui_ammo := 15
var last_spell := GameManager.current_spell

var ui_health := 100

var prev_mana := GameManager.mana

@export var normal_color : Color
@export var warning_color : Color

func _process(_delta):
	update_spell()
	mana_bar.value = GameManager.mana
	mana_label.text = "Mana: " + str(GameManager.mana)
	update_health()
	if GameManager.game_over:
		ammo_anim_player.stop()
	
	if prev_mana < GameManager.mana:
		mana_animation_player.play("Subtle Shake")
	
	if GameManager.mana == 0:
		mana_animation_player.play("Out of Mana")
	else:
		mana_label.set("theme_override_colors/font_color",normal_color)

func _on_mana_depletor_timeout():
	if GameManager.game_over:
		return
	GameManager.decrease_mana(1)
	spawn_mana_effect(-1)

func update_ammo(ammo : int):
	var ammo_changed := false
	if ui_ammo != ammo:
		ammo_changed = true
		ammo_anim_player.play("Pop")
	ui_ammo = ammo
	var left_in_mag : int
	if GameManager.current_spell == "FIREBALL":
		if ammo_changed and prev_mana != GameManager.mana:
			spawn_mana_effect(-2)
			
		left_in_mag = GameManager.mana/2-ammo
		if left_in_mag < 0:
			ammo += left_in_mag
			left_in_mag = 0
		ammo_label.text = "AMMO: " + str(ammo) + "/" + str(left_in_mag)
	else:
		if ammo_changed and prev_mana != GameManager.mana:
			spawn_mana_effect(-3)
			
		left_in_mag = GameManager.mana/5-ammo
		if left_in_mag < 0:
			ammo += left_in_mag
			left_in_mag = 0
		ammo_label.text = "AMMO: " + str(ammo) + "/" + str(left_in_mag)
	if ammo == 0:
		player.change_warning_label(true)
	else:
		player.change_warning_label(false)

	prev_mana = GameManager.mana
func update_spell():
	if last_spell != GameManager.current_spell:
		spell_anim_player.play("Pop")
	spell_label.text = "SPELL: " + GameManager.current_spell
	last_spell = GameManager.current_spell

func update_health():
	var player_health = player.get_node("TakeDamageHandler").health
	if ui_health != player_health:
		health_anim_player.play("Damaged")
		ui_health = player_health
	health_label.text = "Health: " + str(ui_health)
	
func reloading_text():
	ammo_anim_player.play("Reloading")


func spawn_mana_effect(amt : int):
	var instance = mana_effect.instantiate()
	instance.global_position = Vector2(0, 90)
	instance.mana_amount = amt
	get_tree().current_scene.add_child(instance)
	mana_animation_player.play("Subtle Shake")
