extends CharacterBody2D

@onready var player : CharacterBody2D = Loader.player

@export var track_speed = 3.5
@export var missile_speed = 400.0

var initial_dir : Vector2
var move_dir : Vector2 
var dmg = 7

var color_palette = [
	Color("483a2081"), Color("dd9ee464"),Color.BLACK
]

func _ready() -> void:
	move_dir = (player.global_position - global_position)
	change_color_palette(Loader.current_palette)


func _physics_process(delta: float) -> void:
	follow_player()
	var collided = move_and_slide()
	
	
	if collided:
		var collision = get_last_slide_collision()
		var collider = collision.get_collider() #get colliding body
		
		if collider is Player and not collider.is_invincible:
			collider.health_component.damage(dmg)
			collider.collided_with_another_plane.emit()
		
		_on_time_to_explode_timeout()
	
func follow_player():
	var player_dir = (player.global_position - global_position).normalized()
	
	if abs(player_dir.angle_to(move_dir)) <= (PI/2 - deg_to_rad(10)):
		move_dir = move_dir.lerp(player_dir, get_physics_process_delta_time() * track_speed).normalized()
	velocity = move_dir * missile_speed
	rotation = move_dir.angle() + PI/2

@export var death_fx : PackedScene

func _on_time_to_explode_timeout() -> void:
	var d : Node2D = death_fx.instantiate()
	get_tree().root.add_child(d)
	d.start_explosion(global_position, 0.0, 1)
	queue_free()

func change_color_palette(i):
	$MissileA2/overlay.color = color_palette[i]
