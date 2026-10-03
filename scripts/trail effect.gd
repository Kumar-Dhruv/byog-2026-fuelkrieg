extends Line2D

@export var max_points: int = 20
@export var tracker : Marker2D

func _process(delta: float) -> void:
	global_position = Vector2.ZERO # Since top_level is true
	global_rotation = 0.0
	
	# Add current parent position to the start/end of the line
	add_point(tracker.global_position)
	
	# Remove old points if we exceed the maximum length
	if get_point_count() > max_points:
		remove_point(0)
