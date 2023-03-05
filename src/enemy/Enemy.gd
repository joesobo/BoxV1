extends RigidBody2D

@export var speed = 500
@export var max_speed = 1250

var player


func _ready():
	player = get_tree().get_root().get_node("Main/Player")


func _process(delta):
	var direction = player.get_global_position() - global_position
	linear_velocity += direction.normalized() * speed * delta
	linear_velocity = linear_velocity.limit_length(max_speed)

	seek(delta)


func seek(delta):
	if $Ray1.is_colliding() || $Ray2.is_colliding() || $Ray3.is_colliding() || $Ray4.is_colliding():
		var wall_collision_normal = (
			$Ray1.get_collision_normal()
			+ $Ray2.get_collision_normal()
			+ $Ray3.get_collision_normal()
			+ $Ray4.get_collision_normal()
		)
		if wall_collision_normal != Vector2.ZERO:
			var desired = wall_collision_normal * max_speed
			var steer = desired - linear_velocity
			steer = steer.limit_length(speed)

			linear_velocity += steer * delta
	else:
		var desired = player.get_global_position() - global_position
		desired = desired.normalized() * max_speed

		var steer = desired - linear_velocity
		steer = steer.limit_length(speed)

		linear_velocity += steer * delta


func _on_body_entered(body):
	print(body)
	if body == player:
		player.get_node("PlayerHealth").damage(1)
