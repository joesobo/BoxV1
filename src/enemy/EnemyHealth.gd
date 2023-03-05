extends Panel

@export var health = 3


func damage(value: int):
	health -= value
	if health <= 0:
		get_tree().get_root().get_node("Main/Player/Camera2D/GameMenu").score += 1
		get_node("../").queue_free()
