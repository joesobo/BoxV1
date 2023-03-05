extends Panel

@export var health = 10


func damage(value: int):
	health -= value
	if health <= 0:
		print("Game Over")
