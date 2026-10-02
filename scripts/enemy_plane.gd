extends CharacterBody2D

@export var path_generator : PathGenerator
@onready var player : CharacterBody2D = Loader.player

var current_path : Curve2D
var plane_speed = 300.0
var current_distance = 0.0
var path_length = 0.0

func _ready() -> void:
	new_path()
	
func _process(delta: float) -> void:
	follow_path()
	
func follow_path():
	current_distance += plane_speed * get_process_delta_time()
	
	if current_distance >= path_length:
		current_distance = path_length
		current_path = null
		
		new_path()
		return
		
		
		
	var curve_transform = current_path.sample_baked_with_rotation(current_distance)
	global_position = curve_transform.get_origin()
	rotation = curve_transform.get_rotation() + PI/2
	


	
func new_path():
	current_path = path_generator.generate_curve_resource(global_position)
	path_length = current_path.get_baked_length()
	current_distance = 0.0
	#var debug_line = Line2D.new()
	#debug_line.points = current_path.get_baked_points() # Grab the curve's coordinates
	#debug_line.width = 2.0
	#debug_line.default_color = Color.RED
	#debug_line.z_index = 1 # Push it behind the enemy
	
	
