extends Control

var is_paused = false


func _ready():
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	set_pause_state(false)


func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		set_pause_state(!is_paused)


func _on_resume_button_pressed():
	set_pause_state(false)


func _on_options_button_pressed():
	var options = load("res://Menus/Options.tscn").instance()
	get_tree().current_scene.add_child(options)


func _on_quit_button_pressed():
	get_tree().quit()


func set_pause_state(state):
	visible = state
	get_tree().paused = state
	is_paused = state
