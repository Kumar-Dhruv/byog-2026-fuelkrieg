extends Camera2D
@onready var player_plane: CharacterBody2D = $"../PlayerPlane"
var cam_offset = 350.0 #how far ahead cam can see
var target_offset = Vector2.ZERO #initialising to zero

@export var decay_rate: float = 2.0      # How fast the shake fades (higher = faster)
@export var max_offset: Vector2 = Vector2(100, 100)  # Max pixel movement in X and Y
@export var max_roll: float = 0.1        # Max rotation (in radians)
@export var noise_speed: float = 150.0   # How rapidly the camera jiggles

var noise = FastNoiseLite.new()
var noise_time: float = 0.0
var shake_trauma: float = 0.0

func _ready():
	# Initialize the noise generator
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX

func add_trauma(amount: float):
	# Clamp trauma between 0 and 1 so it never spirals out of control
	shake_trauma = min(shake_trauma + amount, 1.0)

func _process(delta):
	if shake_trauma > 0:
		# 1. Decay the trauma linearly over time
		shake_trauma = max(shake_trauma - decay_rate * delta, 0.0)

		# 2. Square the trauma for a non-linear falloff
		var shake_amount = shake_trauma * shake_trauma

		# 3. Move forward through the noise map based on time
		noise_time += delta * noise_speed

		# 4. Apply offset and rotation using distinct coordinates in the noise map
		offset.x = max_offset.x * shake_amount * noise.get_noise_2d(noise_time, 0)
		offset.y = max_offset.y * shake_amount * noise.get_noise_2d(0, noise_time)
		rotation = max_roll * shake_amount * noise.get_noise_2d(noise_time, noise_time)
	else:
	# Snap back to perfect zero when trauma fully decays
		offset = Vector2.ZERO
		rotation = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	if player_plane.velocity.length()>10.0:
		#player moves -> target offset changes
		target_offset = player_plane.velocity.normalized() * cam_offset
	
	#if moving up/down -> camera fov zooms out and offset increases
	if player_plane.boost_state:
		zoom = zoom.lerp(Vector2(0.7,0.7), 3 * delta) #BOOST
		cam_offset = 250.0
	elif Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		zoom = zoom.lerp(Vector2(1,1), 3 * delta) #MOVING
		cam_offset = 250.0
	#else :
		#cam_offset = 150.0
		#zoom = zoom.lerp(Vector2(1.15,1.15), 3 * delta) #STILL
	
	#gives camera the target vector to move to
	var target_pos = player_plane.global_position + target_offset
	
	position = position.lerp(target_pos , 5 * delta)


func _on_health_component_zero_health() -> void:
	add_trauma(1)


func _on_player_plane_collided_with_another_plane() -> void:
	#print("cam shake")
	add_trauma(2)
