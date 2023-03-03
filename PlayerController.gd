extends CharacterBody2D

const GRAVITY := 98

@export var speed := 600
@export var jump_force := 1750
@export var max_fall_speed := 2000
@export var max_wall_jump_count := 3
@export var dash_speed := 2000
@export var dash_time := 0.1

@export var fall_multiplier := 60
@export var low_jump_multiplier := 100

var wall_jump_count := 0
var is_sliding := false
var vertical_input := Vector2.ZERO
var horizontal_input := Vector2.ZERO

var can_dash := false
var dashing := false


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
		velocity.x = horizontal_input.x * speed

		# Sprint
		if Input.is_action_pressed("sprint"):
			velocity.x = horizontal_input.x * speed * 2


func dash():
	if is_on_floor() && !dashing:
		can_dash = true

	if can_dash && Input.is_action_just_pressed("dash"):
		dashing = true
		can_dash = false
		velocity.x = horizontal_input.x * dash_speed
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
		velocity.y = vertical_input.y * jump_force
		wall_jump_count = 0

	if velocity.y < 0 && vertical_input.y == 0:
		velocity.y += GRAVITY * low_jump_multiplier * delta


func fall(delta):
	if is_sliding:
		velocity.y = GRAVITY
	elif check_gravity_fall():
		velocity.y += GRAVITY

	# Fall faster
	if velocity.y > 0:
		velocity.y += GRAVITY * fall_multiplier * delta


func get_input(delta):
	vertical_input = Input.get_vector("", "", "jump", "down")
	horizontal_input = Input.get_vector("left", "right", "", "")

	horizontal_movement()

	dash()

	wall_slide()

	wall_jump()

	jump(delta)

	fall(delta)


func _physics_process(delta):
	get_input(delta)
	move_and_slide()
