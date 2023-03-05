extends Node2D

@export var enemy_scene: PackedScene
@export var should_spawn := true
@export var enemy_num = 2


func _ready():
	if should_spawn:
		for i in range(enemy_num):
			spawn_enemy()


func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	enemy.position = get_global_position()

	get_tree().get_root().call_deferred("add_child", enemy)
