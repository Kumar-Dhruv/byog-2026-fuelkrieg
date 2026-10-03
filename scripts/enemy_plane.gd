extends CharacterBody2D
class_name EnemyPlane
@export var path_generator : PathGenerator
@onready var player : CharacterBody2D = Loader.player
@onready var health_component: Node2D = $HealthComponent


var current_path : Curve2D
@export var plane_speed = 200.0
var current_distance = 0.0
var path_length = 0.0
var is_following_path = false
var is_following_player = false
@export var tracking_modifier = 0.5
var max_tracking = 10
var tracking
var track_point : Vector2
var plane_forward : Vector2 = Vector2.UP

signal finished_path

@export var body_damage = 2
@export var self_damage = 3

#0 - idle
#1 = path follow
#2 = player follow
func switch_state(state_id):
	is_following_path = false
	is_following_player = false
	#$"update player path".stop()
	
	match state_id:
		1:
			is_following_path = true
		2:
			is_following_player = true
			#$"update player path".start()

func _ready() -> void:
	tracking = max_tracking * tracking_modifier
	#start_player_follow()

func get_dist_to_player():
	return global_position.distance_to(player.global_position)

func _process(delta: float) -> void:
	
	plane_forward = plane_forward.rotated(rotation - plane_forward.angle() - PI/2)
	
	DebugDraw2D.arrow_vector(global_position, plane_forward * 50)
	
	if is_following_path:
		follow_path()
	
	if is_following_player:
		follow_player()
	
func set_new_follow_path():
	new_path()
	switch_state(1)
	
func start_player_follow():
	#new_path_to_player()
	track_point = player.global_position
	switch_state(2)

func follow_player():
	track_point = track_point.lerp(player.global_position, get_process_delta_time() * tracking)
	DebugDraw2D.circle(track_point)
	if global_position.distance_to(track_point) <= 2:
		track_point = player.global_position
	global_position += (track_point - global_position).normalized() * plane_speed * get_process_delta_time()
	global_rotation = (track_point - global_position).angle() + PI/2

func follow_path():
	current_distance += plane_speed * get_process_delta_time()
	
	if current_distance >= path_length:
		current_distance = path_length
		current_path = null
		switch_state(0)
		finished_path.emit()
		return
		
	var curve_transform = current_path.sample_baked_with_rotation(current_distance)
	global_position = curve_transform.get_origin()
	rotation = curve_transform.get_rotation() + PI/2
	
func new_path():
	current_path = path_generator.generate_curve_resource(global_position)
	path_length = current_path.get_baked_length()
	current_distance = 0.0

func _physics_process(delta: float) -> void:
	if health_component.Health<=0:
		queue_free()

	
	var collided = move_and_slide()
	
	if collided:
		var collision = get_last_slide_collision()
		var collider = collision.get_collider() #get colliding body
		
		if collider is Player and not collider.is_invincible:
			collider.health_component.damage(body_damage)
			collider.invincible()
		health_component.damage(self_damage)
		
		queue_free()
