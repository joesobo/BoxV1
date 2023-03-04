extends Node2D

@export var bullet_scene: PackedScene
@export var bullet_speed: float = 500


func _process(_delta):
	look_at(get_global_mouse_position())

	if Input.is_action_just_pressed("shoot"):
		var bullet = bullet_scene.instantiate()

		bullet.position = $SpawnPosition.get_global_position()
		bullet.rotation_degrees = rotation_degrees
		bullet.set_linear_velocity(Vector2(bullet_speed, 0).rotated(rotation))

		get_tree().get_root().call_deferred("add_child", bullet)
