extends Panel

@export var max_health := 10
var health: float = max_health
var health_panel: Panel
var initial_width
var can_damage := true
var player

func _ready():
	player = get_node('../../Player')

	health_panel = $HealthPanel

	initial_width = health_panel.get_size().x


func damage(value: int, direction: Vector2):
	if can_damage:
		can_damage = false

		health -= value

		# Knockback
		player.knockback_velocity = direction.normalized() * 1000

		# Update health bar
		var new_width = initial_width * (health / max_health)
		health_panel.set_size(Vector2(new_width, health_panel.get_size().y))

		if health <= 0:
			print("Game Over")

		# Reset knockback
		await get_tree().create_timer(0.5).timeout
		player.knockback_velocity = Vector2.ZERO

		# Reset damage
		await get_tree().create_timer(0.5).timeout
		can_damage = true
