extends Node2D

@export var enemy_scene: PackedScene


func _ready():
	var enemy = enemy_scene.instantiate()
	enemy.position = get_global_position()

	get_tree().get_root().call_deferred("add_child", enemy)
