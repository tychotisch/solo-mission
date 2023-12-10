extends Node2D

@onready var menu: Control = $Menu
@onready var highscore_label: Label = $Menu/Highscore/HighscoreLabel
@onready var score_label: Label = $ScoreLabel

var score := 0
var high_score := 0

func _ready() -> void:
	Events.connect("Died", update_score)
	Events.connect("Player_died", show_menu)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape"):
		show_menu()

	if menu.visible:
		get_tree().paused = true

func update_score():
	score += 1
	score_label.text = str(score)
	if score > high_score:
		high_score += 1
		highscore_label.text = str(high_score)

func show_menu():
	menu.visible = true

func _on_resume_pressed() -> void:
	get_tree().paused = false
	menu.visible = false

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
