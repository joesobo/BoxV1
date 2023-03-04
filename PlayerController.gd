extends CharacterBody2D

const GRAVITY := 98

@export var speed := 600
@export var jump_force := 1750
@export var max_fall_speed := 2000
@export var max_wall_jump_count := 3
@export var dash_speed := 2000
@export var dash_time := 0.1
@export var knockback_speed := 1000

@export var fall_multiplier := 60
@export var low_jump_multiplier := 100

@export var wall_jump_count := 0
@export var is_sliding := false
@export var is_sprinting := false
@export var is_jumping := false
@export var can_double_jump := false
@export var knockback_direction := Vector2.ZERO

@export var dashing := false
var can_dash := false

var input := Vector2.ZERO


func next_to_wall():
	return next_to_left_wall() || next_to_right_wall()


func next_to_left_wall():
	return $RightWall.is_colliding()


func next_to_right_wall():
	return $LeftWall.is_colliding()


func is_aiming_into_wall():
	return (
		(next_to_right_wall() && get_wall_normal().x > 0 && input.x < 0)
		|| (next_to_left_wall() && get_wall_normal().x < 0 && input.x > 0)
	)


func check_wall_jump():
	return (
		next_to_wall()
		&& Input.is_action_pressed("jump")
		&& wall_jump_count < max_wall_jump_count
		&& velocity.y > 0
	)


func check_gravity_fall():
	return !is_sliding && !is_on_floor() && velocity.y < GRAVITY


func horizontal_movement():
	if wall_jump_count == 0 && !dashing:
		velocity.x = input.x * speed
		is_sprinting = false

		# Sprint
		if Input.is_action_pressed("sprint"):
			velocity.x = input.x * speed * 2
			is_sprinting = true


func dash():
	if is_on_floor() && !dashing:
		can_dash = true

	if can_dash && Input.is_action_just_pressed("dash"):
		dashing = true
		can_dash = false
		velocity.x = input.x * dash_speed
		await get_tree().create_timer(dash_time).timeout
		dashing = false


func wall_slide():
	is_sliding = velocity.y > 0 && is_aiming_into_wall()


func wall_jump():
	if check_wall_jump():
		is_sliding = false

		velocity.y = -1 * jump_force
		velocity.x = get_wall_normal().x * speed

		wall_jump_count += 1


func jump(delta):
	if is_on_floor():
		# Reset Jump
		can_double_jump = false
		is_jumping = false
		wall_jump_count = 0

		# Normal Jump
		velocity.y = input.y * jump_force
		if velocity.y < 0:
			print(1)
			is_jumping = true
			can_double_jump = true

	# Double Jump
	if !is_on_floor() && can_double_jump && Input.is_action_just_pressed("jump"):
		print(2)
		velocity.y = input.y * jump_force
		can_double_jump = false

	# Dynamic Jump
	if velocity.y < 0 && input.y == 0:
		velocity.y += GRAVITY * low_jump_multiplier * delta


func fall(delta):
	if is_sliding:
		velocity.y = GRAVITY
	elif check_gravity_fall():
		velocity.y += GRAVITY

	# Fall faster
	if velocity.y > 0:
		velocity.y += GRAVITY * fall_multiplier * delta


func knockback():
	if knockback_direction != Vector2.ZERO:
		velocity = -knockback_direction * knockback_speed


func get_input():
	if Input.is_action_pressed("left"):
		input.x = -1
	elif Input.is_action_pressed("right"):
		input.x = 1
	else:
		input.x = 0

	if Input.is_action_pressed("jump"):
		input.y = -1
	else:
		input.y = 0


func _physics_process(delta):
	get_input()

	# Moving
	horizontal_movement()

	dash()

	wall_slide()

	wall_jump()

	jump(delta)

	fall(delta)

	knockback()

	# Apply Movement
	move_and_slide()
