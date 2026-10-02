extends Node2D

class_name PathGenerator

@export var num_bends = 1

@export var max_radius = 200.0

@export var max_angle = (45.0)

@export var enemy_plane : CharacterBody2D

@onready var player : CharacterBody2D = Loader.player

func _process(delta: float) -> void:
	DebugDraw2D.circle(player.global_position, max_radius)

func generate_curve_resource(start = enemy_plane.global_position) -> Curve2D:
	var d = start.distance_to(player.global_position)
	var theta = deg_to_rad(randi_range(-max_angle, max_angle))
	var psi = (player.global_position - start).angle()
	var alpha = psi + theta
	
	var l = d * cos(theta) + sqrt(max((max_radius ** 2 - (d * sin(theta)) ** 2), 0.0))  
	var end = Vector2(start.x + l * cos(alpha), start.y + l * sin(alpha))
	
	var curve = Curve2D.new()
	var max_curve_offset = 150.0
	var total_distance = start.distance_to(end)
	var direction = (end - start).normalized()
	var normal = Vector2(-direction.y, direction.x)
	curve.add_point(start)
	
	for i in range(1, num_bends + 1):
		var fraction = float(i) / (num_bends + 1)
		var base_point = start.lerp(end, fraction)
		var random_shift = randf_range(-max_curve_offset, max_curve_offset)
		var final_point = base_point + (normal * random_shift)
		
		var handle_length = (total_distance / num_bends) * 0.25 
		var control_in = -direction * handle_length
		var control_out = direction * handle_length
		
		curve.add_point(final_point, control_in, control_out)
		
	curve.add_point(end)
	return curve
