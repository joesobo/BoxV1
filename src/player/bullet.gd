extends RigidBody2D


func _ready():
	self_destruct()


func _on_body_entered(body: Node):
	if body.name == "Enemy":
		body.get_node("EnemyHealth").damage(1)

	queue_free()


func self_destruct():
	await get_tree().create_timer(1).timeout
	queue_free()
