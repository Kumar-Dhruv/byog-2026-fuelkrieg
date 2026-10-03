extends CharacterBody2D


var Velocity : Vector2 = Vector2.ZERO
@export var dmg = 1

func _physics_process(delta: float) -> void:
	global_position += Velocity * delta
	var collided = move_and_slide()
	
	if collided:
		var collision = get_last_slide_collision()
		var collider = collision.get_collider() #get colliding body
		
		if collider.is_in_group("enemy"):
			collider.health_component.damage(dmg)
		
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() :
	queue_free()
