extends Control

@onready var restart_button_label = $RestartButton/RestartLabel
@onready var seconds_survived = $StatContainer/SecondsSurvived
@onready var enemies_killed = $StatContainer/EnemiesKilled
@onready var mana_collected = $StatContainer/ManaCollected
@onready var final_score = $FinalScore

@export var menu_music : AudioStream

func _on_restart_button_mouse_entered():
	var tween = create_tween()
	tween.tween_property(restart_button_label, "scale", Vector2(1.2, 1.2), 0.1)


func _on_restart_button_mouse_exited():
	var tween = create_tween()
	tween.tween_property(restart_button_label, "scale", Vector2(1, 1), 0.1)



func _on_restart_button_down():
	var tween = create_tween()
	tween.tween_property(restart_button_label, "scale", Vector2(0.8, 0.8), 0.1)


func _on_restart_button_up():
	var tween = create_tween()
	tween.tween_property(restart_button_label, "scale", Vector2(1, 1), 0.2)
	await tween.finished
	GameManager.reset_stats()
	get_tree().reload_current_scene()


func _on_visibility_changed():
	if visible:
		MusicPlayer.change_music(menu_music)
		$AnimationPlayer.play("End Sequence")
		display_stats()

func display_stats():
	await get_tree().create_timer(0.01).timeout
	seconds_survived.text = "SECONDS SURVIVED: " + str(GameManager.seconds_survived)
	mana_collected.text = "MANA COLLECTED: " + str(GameManager.mana_gained)
	enemies_killed.text = "ENEMIES KILLED: " + str(GameManager.enemies_killed)
	
	final_score.text = "SCORE: " + str(GameManager.score)
	
