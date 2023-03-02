extends CharacterBody2D

@export var speed = 600
@export var jumpForce = 2000


func get_input():
	var horizontal_movement = Input.get_vector("left", "right", "", "")
	var vertical_movement = Input.get_vector("", "", "jump", "down")

	velocity.x = horizontal_movement.x * speed

	if is_on_floor():
		velocity.y = vertical_movement.y * jumpForce
	else:
		velocity.y += 98


func _physics_process(_delta):
	get_input()
	move_and_slide()
