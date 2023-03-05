extends Control


func _ready():
	visible = false


func game_over():
	var game_menu = get_node("../GameMenu")
	$VBoxContainer/Score.text = "Score: " + str(game_menu.score)
	visible = true
	get_tree().paused = true


func _on_replay_pressed():
	load("res://src/scenes/main.tscn").instance()


func _on_quit_pressed():
	get_tree().quit()
