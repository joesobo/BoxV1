extends Panel

@export var max_health := 10
var health: float = max_health
var health_panel: Panel
var initial_width
var can_damage := true


func _ready():
	health_panel = $HealthPanel

	initial_width = health_panel.get_size().x


func damage(value: int):
	if can_damage:
		health -= value
		can_damage = false

		var new_width = initial_width * (health / max_health)
		health_panel.set_size(Vector2(new_width, health_panel.get_size().y))

		if health <= 0:
			print("Game Over")

		await get_tree().create_timer(1).timeout
		can_damage = true
