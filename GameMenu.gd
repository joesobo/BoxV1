extends Control

var time = 0
@export var score = 0

func count_time():
	await get_tree().create_timer(1).timeout
	time += 1
	count_time()

func stringify_time():
	var minutes = int(time / 60)
	var seconds = time % 60
	var minutes_string = str(minutes)
	var seconds_string = str(seconds)
	if seconds < 10:
		seconds_string = "0" + seconds_string

	return minutes_string + "m " + seconds_string + "s"

func _ready():
	count_time()

func _process(_delta):
	$VBoxContainer/Time.text = "Time: " + stringify_time()
	$VBoxContainer/Score.text = "Score: " + str(score)
