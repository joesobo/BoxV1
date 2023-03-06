extends Control

@export var frame_rate = 10

var frame_count = 0
var player

@onready var horizontal_speed = $Container/HorizontalSpeed
@onready var vertical_speed = $Container/VerticalSpeed
@onready var wall_jumps = $Container/WallJumps
@onready var can_wall_jump = $Container/CanWallJump
@onready var is_grounded = $Container/IsGrounded
@onready var is_wall_sliding = $Container/IsWallSliding
@onready var is_jumping = $Container/IsJumping
@onready var is_sprinting = $Container/IsSprinting
@onready var is_dashing = $Container/IsDashing
@onready var can_double_jump = $Container/CanDoubleJump


func _process(_delta):
	player = get_node("../../../Player")
	frame_count += 1
	if frame_count % frame_rate == 0:
		process_function()


func process_function():
	horizontal_speed.value = abs(player.velocity.x)
	horizontal_speed.show_percentage = false
	$Container/HorizontalSpeed/Label.text = "vX: " + str(round(player.velocity.x))

	vertical_speed.value = abs(player.velocity.y)
	vertical_speed.show_percentage = false
	$Container/VerticalSpeed/Label.text = "vY: " + str(round(player.velocity.y))

	wall_jumps.text = "Wall Jumps: " + str(player.wall_jump_count)
	can_wall_jump.text = "Can Wall Jump: " + str(player.check_wall_jump())
	is_grounded.text = "Grounded: " + str(player.is_on_floor())
	is_wall_sliding.text = "Wall Sliding: " + str(player.is_sliding)
	is_jumping.text = "Jumping: " + str(player.is_jumping)
	is_sprinting.text = "Sprinting: " + str(player.is_sprinting)
	is_dashing.text = "Dashing: " + str(player.dashing)
	can_double_jump.text = "Double Jump: " + str(player.check_double_jump())
