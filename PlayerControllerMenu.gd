extends Control

@export var frame_rate = 10

var frame_count = 0


func _process(_delta):
	frame_count += 1
	if frame_count % frame_rate == 0:
		process_function()


func process_function():
	var player := get_node("../../../Player")

	$Container/HorizontalSpeed.value = abs(player.velocity.x)
	$Container/HorizontalSpeed.show_percentage = false
	$Container/HorizontalSpeed/Label.text = "vX: " + str(round(player.velocity.x))

	$Container/VerticalSpeed.value = abs(player.velocity.y)
	$Container/VerticalSpeed.show_percentage = false
	$Container/VerticalSpeed/Label.text = "vY: " + str(round(player.velocity.y))

	$Container/WallJumps.text = "Wall Jumps: " + str(player.wall_jump_count)
	$Container/IsGrounded.text = "Grounded: " + str(player.is_on_floor())
	$Container/IsWallSliding.text = "Wall Sliding: " + str(player.is_sliding)
	$Container/IsJumping.text = "Jumping: " + str(player.is_jumping)
	$Container/IsSprinting.text = "Sprinting: " + str(player.is_sprinting)
	$Container/IsDashing.text = "Dashing: " + str(player.dashing)
	$Container/CanDoubleJump.text = "Double Jump: " + str(player.can_double_jump)
