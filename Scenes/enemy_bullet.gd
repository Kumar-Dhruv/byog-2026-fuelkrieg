extends CharacterBody2D

var dmg = 1

func _physics_process(delta: float) -> void:
	var collided = move_and_slide()
	
	if collided:
		var collision = get_last_slide_collision()
		var collider = collision.get_collider() #get colliding body
		
		if collider is Player and not collider.is_invincible:
			collider.health_component.damage(dmg)
		
		queue_free()
