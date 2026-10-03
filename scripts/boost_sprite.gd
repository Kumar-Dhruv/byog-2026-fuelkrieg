extends CharacterBody2D
@onready var player_plane: Player = $".."
@onready var fuel_component: Node2D = $"../FuelComponent"
var is_ejected : bool = false
@onready var health_component: Node2D = $"../../HealthComponent"

func _physics_process(delta: float) -> void:
	if fuel_component.boost_destroy : 
		queue_free()
		health_component.damage(3)
	
	if is_ejected:
		velocity += get_gravity() * delta
	move_and_slide()
	
	if fuel_component.boost_eject and not is_ejected :
		if Input.is_action_just_pressed("boost"):
			eject()
			
func eject():
	var dir = -player_plane.velocity.normalized()
	velocity += dir * 500
	is_ejected = true
	fuel_component.boost_is_out = true

func _on_visible_on_screen_notifier_2d_screen_exited() :
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and is_ejected:
		body.queue_free()
		queue_free()
