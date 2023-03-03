extends CharacterBody2D

@export var speed := 600
@export var jump_force := 1750
@export var max_fall_speed := 2000
@export var max_wall_jump_count := 3

@export var fall_multiplier := 60
@export var low_jump_multiplier := 100

const gravity := 98

var wall_jump_count := 0
var is_sliding := false
var vertical_input := Vector2.ZERO
var horizontal_input := Vector2.ZERO


func next_to_wall():
	return next_to_left_wall() || next_to_right_wall()


func next_to_left_wall():
	return $RightWall.is_colliding()


func next_to_right_wall():
	return $LeftWall.is_colliding()


func is_aiming_into_wall():
	return (
		(next_to_right_wall() && get_wall_normal().x > 0 && horizontal_input.x < 0)
		|| (next_to_left_wall() && get_wall_normal().x < 0 && horizontal_input.x > 0)
	)

func check_wall_slide():
	return velocity.y > 0 && is_aiming_into_wall()

func check_wall_jump():
	return (
		next_to_wall()
		&& Input.is_action_pressed("jump")
		&& wall_jump_count < max_wall_jump_count
		&& velocity.y > 0
	)

func check_gravity_fall():
	return !is_sliding && !is_on_floor() && velocity.y < gravity

func get_input(delta):
	vertical_input = Input.get_vector("", "", "jump", "down")
	horizontal_input = Input.get_vector("left", "right", "", "")

	# Horizontal movement
	if wall_jump_count == 0:
		velocity.x = horizontal_input.x * speed

	# Wall slide
	is_sliding = check_wall_slide()

	# Wall jump
	if check_wall_jump():
		is_sliding = false

		velocity.y = -1 * jump_force
		velocity.x = get_wall_normal().x * speed

		wall_jump_count += 1

	# Jump
	if is_on_floor():
		velocity.y = vertical_input.y * jump_force
		wall_jump_count = 0

	# Fall
	if is_sliding:
		velocity.y = gravity
	elif check_gravity_fall():
		velocity.y += gravity

	# Fall faster
	if velocity.y > 0:
		velocity.y += gravity * fall_multiplier * delta
	# Dynamic Jump
	elif velocity.y < 0 && vertical_input.y == 0:
		velocity.y += gravity * low_jump_multiplier * delta


func _physics_process(delta):
	get_input(delta)
	move_and_slide()
