extends CharacterBody2D

@onready var player : CharacterBody2D = Loader.player

@export var track_speed = 3.5
@export var missile_speed = 400.0

var initial_dir : Vector2
var move_dir : Vector2 
var dmg = 2

func _ready() -> void:
	move_dir = (player.global_position - global_position)
	



func _physics_process(delta: float) -> void:
	follow_player()
	var collided = move_and_slide()
	
	
	if collided:
		var collision = get_last_slide_collision()
		var collider = collision.get_collider() #get colliding body
		
		if collider is Player and not collider.is_invincible:
			collider.health_component.damage(dmg)
		
		queue_free()
	
func follow_player():
	var player_dir = (player.global_position - global_position).normalized()
	
	if abs(player_dir.angle_to(move_dir)) <= PI/2:
		move_dir = move_dir.lerp(player_dir, get_physics_process_delta_time() * track_speed).normalized()
	velocity = move_dir * missile_speed
	rotation = move_dir.angle() - PI/2

func _on_time_to_explode_timeout() -> void:
	queue_free()
