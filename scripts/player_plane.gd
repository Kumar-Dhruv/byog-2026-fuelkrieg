extends CharacterBody2D
class_name  Player
@export var top_speed = 200.0
@export var acc_velo_graph : Curve
@export var is_invincible : bool = false

@onready var plane_forward = Vector2(0, -1) #we adjust this via keyboard
@onready var plane_normal = Vector2(1, 0)  #normal
@onready var health_component: Node2D = $"../HealthComponent"
@onready var sprite: Sprite2D = $Sprite2D


#var angular_acceleration = 1.0
var turn_speed = 3.0
var acceleration = 150.0
var max_acceleration = 300.0
var accleration_modifier_when_turning = 1.5
var brake_strength = 200.0
var gravity = 10.0
var input_dir := Vector2(0, 0) # x = acc, y = rot
var brake_dir : Vector2
var boost_state : bool = false
var boost_speed = 500.0
var blink_tween : Tween

func _ready() -> void:
	
	Loader.player = self
	
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
	
	#adding
	plane_forward = plane_forward.rotated((input_dir.y) * (turn_speed if (not boost_state) else turn_speed * 0.35) * get_physics_process_delta_time())
	
	acceleration = max_acceleration * acc_velo_graph.sample(velocity.length() / top_speed)
	#print(acceleration)
	
	if boost_state:
		# 1. Ramp speed up to 300 smoothly so the camera doesn't jump instantly
		var target_speed = move_toward(velocity.length(), boost_speed, 600.0 * get_physics_process_delta_time())
		if target_speed < top_speed: 
			target_speed = boost_speed # Ensure immediate high speed if starting from rest
			
		# 2. Get current flight direction
		var flight_dir = velocity.normalized() if velocity.length() > 0 else plane_forward
		
		# 3. Smoothly rotate flight_dir toward plane_forward along an arc (preserves turning momentum)
		var arc_dir = flight_dir.slerp(plane_forward,4.0 * get_physics_process_delta_time()).normalized()
		
		# 4. Set velocity maintaining locked boost speed with smooth turning
		velocity = arc_dir * target_speed
	
	else :
		# linear
		if input_dir.x != 0.0:
			velocity += plane_forward * input_dir.x * (acceleration if (!input_dir.y) else acceleration * accleration_modifier_when_turning) * get_physics_process_delta_time()
			brake_dir = Vector2.ZERO
			
		elif velocity.length() >= 0.0:
			
			brake_dir = -velocity.normalized()
			velocity += brake_dir * brake_strength * get_physics_process_delta_time()
			
		
		if velocity.length() >= top_speed:
			velocity = velocity.normalized() * top_speed
		
		
		#velocity += plane_normal * (-input_dir.y) * angular_acceleration * get_physics_process_delta_time()
		#global_rotation += (input_dir.y) * turn_speed * get_physics_process_delta_time()

func _input(event: InputEvent) -> void:
	input_dir.x = Input.get_axis("ui_down", "ui_up")
	input_dir.y = Input.get_axis("ui_left", "ui_right")
	
	if event.is_action_pressed("boost"):
		boost_state = true
	elif event.is_action_released("boost"):
		boost_state = false

func invincible():
	if is_invincible: return
	
	is_invincible = true
	
	#looping tween to alternate the opacity
	blink_tween = create_tween().set_loops()
	blink_tween.tween_property(sprite, "modulate:a", 0.2, 0.15)
	blink_tween.tween_property(sprite, "modulate:a", 1.0, 0.15)

	await get_tree().create_timer(3).timeout
	
	# Safety check in case the player died
	if not is_inside_tree() or not is_instance_valid(sprite):
		return

	is_invincible = false
	if blink_tween:
		blink_tween.kill()
		
	sprite.modulate.a = 1.0 
