extends RigidBody2D

@export var speed = 400
var velocity = Vector2.ZERO

func get_input():
	var input_direction = Input.get_vector("left", "right", "jump", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_collide(velocity * delta)
