extends CharacterBody2D
class_name Player
@export var top_speed = 200.0
@export var acc_velo_graph : Curve
@export var is_invincible : bool = false

@onready var plane_forward = Vector2(0, -1) #we adjust this via keyboard
@onready var plane_normal = Vector2(1, 0)  #normal
@onready var health_component: Node2D = $"../HealthComponent"
#@onready var sprite: Sprite2D = $PlaneBody

signal collided_with_another_plane

#var angular_acceleration = 1.0
var turn_speed = 4.5
var acceleration = 150.0
var max_acceleration = 300.0
var accleration_modifier_when_turning = 2.5
var brake_strength = 650.0
var gravity = 10.0
var input_dir := Vector2(0, 0) # x = acc, y = rot
var brake_dir : Vector2
var boost_state : bool = false
var boost_speed = 500.0
var can_boost : bool = true
var blink_tween : Tween
var stop_movement = false

func _ready() -> void:
	
	Loader.player = self
	Loader.player_died.connect(disable)
	global_rotation = plane_forward.angle_to(Vector2.UP)
	plane_normal = plane_forward.rotated(PI/2)

func _physics_process(delta: float) -> void:
	#DebugDraw2D.arrow_vector(global_position, plane_forward * 100, Color.RED)
	#DebugDraw2D.arrow_vector(global_position, plane_normal * 100, Color.BLUE)
	#
	#DebugDraw2D.arrow_vector(global_position, velocity, Color.YELLOW)
	
	handle_movement()
	
	move_and_slide()
	
	#health label
	$Label.text = str(health_component.Health)

func handle_movement():
	if stop_movement:
		return
		
	acceleration = max_acceleration * acc_velo_graph.sample(velocity.length() / top_speed)
	
	var acc_dir = Vector2(input_dir.x, input_dir.y).normalized()
	DebugDraw2D.arrow_vector(global_position, acc_dir * 10)
	#global_rotation = -plane_forward.angle_to(Vector2.UP)
	#plane_normal = plane_forward.rotated(PI/2)
	#
	##adding
	#var t = turn_speed
	#if not boost_state:
		#if input_dir.x <= 0:
			#t *= 1.35
	#else:
		#t *= 0.35
	#plane_forward = plane_forward.rotated((input_dir.y) * t * get_physics_process_delta_time())
	
	
	#print(acceleration)
	
	#if boost_state and can_boost:
		## 1. Ramp speed up to 300 smoothly so the camera doesn't jump instantly
		#var target_speed = move_toward(velocity.length(), boost_speed, 600.0 * get_physics_process_delta_time())
		#if target_speed < top_speed: 
			#target_speed = boost_speed # Ensure immediate high speed if starting from rest
			#
		## 2. Get current flight direction
		#var flight_dir = velocity.normalized() if velocity.length() > 0 else plane_forward
		#
		## 3. Smoothly rotate flight_dir toward plane_forward along an arc (preserves turning momentum)
		#var arc_dir = flight_dir.slerp(plane_forward,4.0 * get_physics_process_delta_time()).normalized()
		#
		## 4. Set velocity maintaining locked boost speed with smooth turning
		#velocity = arc_dir * target_speed
	#
	#else :
		## linear
		#if input_dir.x != 0.0:
			#velocity += plane_forward * input_dir.x * (acceleration if (!input_dir.y) else acceleration * accleration_modifier_when_turning) * get_physics_process_delta_time()
			#brake_dir = Vector2.ZERO
			#
		#elif velocity.length() >= 0.0:
			#
			#brake_dir = -velocity.normalized()
			#velocity += brake_dir * brake_strength * get_physics_process_delta_time()
			#
		#
		#if velocity.length() >= top_speed:
			#velocity = velocity.normalized() * top_speed
		
		
		#velocity += plane_normal * (-input_dir.y) * angular_acceleration * get_physics_process_delta_time()
		#global_rotation += (input_dir.y) * turn_speed * get_physics_process_delta_time()

func _input(event: InputEvent) -> void:
	input_dir.x = Input.get_axis("ui_down", "ui_up")
	#input_dir.x = clampf(input_dir.x, 0, 1.0)
	input_dir.y = (Input.get_axis("ui_left", "ui_right"))
	
	if event.is_action_pressed("boost") and can_boost:
		boost_state = true
	elif event.is_action_released("boost"):
		boost_state = false

func invincible():
	pass


func disable():
	stop_movement = true
	velocity = Vector2.ZERO


func _on_fuel_component_body_fuel_empty() -> void:
	turn_speed *= 0.7
	top_speed *= 0.5

var y = 4
func _on_laser_toggle_laser_turning(x: Variant) -> void:
	if x:
		y = turn_speed
		turn_speed = 0.7
	else:
		turn_speed = y
