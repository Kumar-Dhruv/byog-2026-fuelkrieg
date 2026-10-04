extends Area2D

@export var health_component : Node2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player and not body.is_invincible:
		body.health_component.damage(1000)
		#collider.invincible()
