extends CharacterBody2D

var dmg = 1

var color_palette = [
	Color("483a20"),
	Color.BLACK
]

func _physics_process(delta: float) -> void:
	var collided = move_and_slide()
	
	if collided:
		var collision = get_last_slide_collision()
		var collider = collision.get_collider() #get colliding body
		
		if collider is Player and not collider.is_invincible:
			collider.health_component.damage(dmg)
		
		queue_free()

func change_color_palette(i):
	$Sprite2D/overlay.color = color_palette[i]
