extends Panel

@export var max_health := 3
var health: float = max_health
var health_panel: Panel
var initial_width


func _ready():
	health_panel = $HealthPanel

	initial_width = health_panel.get_size().x


func damage(value: int):
	health -= value

	var new_width = initial_width * (health / max_health)
	health_panel.set_size(Vector2(new_width, health_panel.get_size().y))

	if health <= 0:
		get_tree().get_root().get_node("Main/Player/Camera2D/GameMenu").score += 1
		get_node("../").queue_free()
