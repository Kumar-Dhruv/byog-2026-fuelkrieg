extends CharacterBody2D
@onready var player_plane: Player = Loader.player
@export var fuel_component: Node2D 
@export var health_component: Node2D 
var is_ejected : bool = false
@export var parts_manager : Node2D

func _physics_process(delta: float) -> void:
	if fuel_component.laser_destroy : 
		queue_free()
		health_component.damage(3)

	if is_ejected:
		velocity += get_gravity() * delta
	move_and_slide()
	
	if fuel_component.laser_eject and not is_ejected :
		if Input.is_action_just_pressed("laser"):
			eject()
			
	
func eject():
	var dir = player_plane.velocity.normalized()
	global_position = player_plane.global_position
	#top_level = true
	velocity += dir * 500
	is_ejected = true
	parts_manager.remove_part(3)
	$Laser.visible = true
	fuel_component.laser_is_out = true

func _on_visible_on_screen_notifier_2d_screen_exited() :
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy") and is_ejected:
		body.queue_free()
		queue_free()
