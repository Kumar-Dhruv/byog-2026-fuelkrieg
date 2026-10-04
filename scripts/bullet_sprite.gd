extends CharacterBody2D


var Velocity : Vector2 = Vector2.ZERO
@export var dmg = 1

var color_palette = [
	Color("e7bb63"), Color("dd9ee4"),Color.WHITE
]

func _ready() -> void:
	change_color_palette(Loader.current_palette)


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
	
func change_color_palette(i):
	$Node2D.modulate = color_palette[i]
