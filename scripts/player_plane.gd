extends CharacterBody2D

@export var top_speed = 200.0
@export var acc_velo_graph : Curve

@onready var plane_forward = Vector2(0, -1) #we adjust this via keyboard
@onready var plane_normal = Vector2(1, 0)  #normal
#var angular_acceleration = 1.0
var turn_speed = 3.0
var acceleration = 150.0
var max_acceleration = 300.0
var accleration_modifier_when_turning = 1.5
var brake_strength = 200.0
var gravity = 10.0
var input_dir := Vector2(0, 0) # x = acc, y = rot
var brake_dir : Vector2

func _ready() -> void:
	global_rotation = plane_forward.angle_to(Vector2.UP)
	plane_normal = plane_forward.rotated(PI/2)

func _physics_process(delta: float) -> void:
	DebugDraw2D.arrow_vector(global_position, plane_forward * 100, Color.RED)
	DebugDraw2D.arrow_vector(global_position, plane_normal * 100, Color.BLUE)
	
	DebugDraw2D.arrow_vector(global_position, velocity, Color.YELLOW)
	
	handle_movement()
	
	move_and_slide()

func handle_movement(stop_movement = false):
	if stop_movement:
		return
	
	

	global_rotation = -plane_forward.angle_to(Vector2.UP)
	plane_normal = plane_forward.rotated(PI/2)
	
	
	acceleration = max_acceleration * acc_velo_graph.sample(velocity.length() / top_speed)
	print(acceleration)
	
	# linear
	if input_dir.x != 0.0:
		velocity += plane_forward * input_dir.x * (acceleration if (!input_dir.y) else acceleration * accleration_modifier_when_turning) * get_physics_process_delta_time()
		brake_dir = Vector2.ZERO
		
	elif velocity.length() >= 0.0:
		
		brake_dir = -velocity.normalized()
		velocity += brake_dir * brake_strength * get_physics_process_delta_time()
		
	
	if velocity.length() >= top_speed:
		velocity = velocity.normalized() * top_speed
	#adding
	plane_forward = plane_forward.rotated((input_dir.y) * turn_speed * get_physics_process_delta_time())
	
	#velocity += plane_normal * (-input_dir.y) * angular_acceleration * get_physics_process_delta_time()
	#global_rotation += (input_dir.y) * turn_speed * get_physics_process_delta_time()

func _input(event: InputEvent) -> void:
	input_dir.x = Input.get_axis("ui_down", "ui_up")
	input_dir.y = Input.get_axis("ui_left", "ui_right")
