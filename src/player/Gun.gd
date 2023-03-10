extends Node2D

@export var bullet_scene: PackedScene
@export var bullet_speed: float = 500
@export var knockback_time: float = 0.1
@export var knockback_speed := 1000


func _process(_delta):
	look_at(get_global_mouse_position())

	if Input.is_action_just_pressed("shoot"):
		# var player := get_node("../../Player")
		var bullet = bullet_scene.instantiate()

		# Spawn bullet
		bullet.position = $SpawnPosition.get_global_position()
		bullet.rotation_degrees = rotation_degrees
		bullet.set_linear_velocity(Vector2(bullet_speed, 0).rotated(rotation))

		# Knockback on shoot
		# var direction = Vector2(1, 0).rotated(rotation)
		# player.knockback_velocity = -direction.normalized() * knockback_speed

		# # Stop knockback after a while
		# await get_tree().create_timer(knockback_time).timeout
		# player.knockback_velocity = Vector2.ZERO

		get_tree().get_root().call_deferred("add_child", bullet)
