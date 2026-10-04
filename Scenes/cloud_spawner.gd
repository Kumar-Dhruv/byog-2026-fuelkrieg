extends Node2D

@export var cloud_sprites : Array[Resource]
@export var cloud_scene: PackedScene
@export var max_clouds: int = 40

# The bubble where clouds spawn
@export var spawn_radius: float = 1200.0 
# The boundary where clouds get destroyed
@export var despawn_radius: float = 1500.0 

func _ready():
	# Populate the screen with initial clouds
	for i in range(max_clouds):
		spawn_cloud(true)

func _process(_delta):
	var camera = get_viewport().get_camera_2d()
	if not camera:
		return
		
	var cam_pos = camera.global_position
	var active_cloud_count = 0

	# Check distance for all child nodes (clouds)
	for cloud in get_children():
		if cloud.global_position.distance_to(cam_pos) > despawn_radius:
			cloud.queue_free() # Destroy the cloud
		else:
			active_cloud_count += 1

	# Instantiate new clouds until we reach the max limit again
	while active_cloud_count < max_clouds:
		spawn_cloud(false)
		active_cloud_count += 1

func spawn_cloud(is_initial: bool):
	var cloud : Sprite2D = cloud_scene.instantiate()
	cloud.texture = cloud_sprites.pick_random()
	cloud.scale = Vector2(1, 1) * randi_range(2, 3.5)
	cloud.modulate.a = [0.25, 0.4, 0.5].pick_random()
	
	
	var cam_pos = global_position
	if get_viewport().get_camera_2d():
		cam_pos = get_viewport().get_camera_2d().global_position
		
	var random_angle = randf() * TAU
	
	if is_initial:
		# Use square root to distribute evenly across the circle's area
		var random_dist = sqrt(randf()) * spawn_radius
		cloud.global_position = cam_pos + Vector2(cos(random_angle), sin(random_angle)) * random_dist
	else:
		# New clouds still spawn exactly on the perimeter as you fly
		cloud.global_position = cam_pos + Vector2(cos(random_angle), sin(random_angle)) * spawn_radius
		
	# Add the new cloud to the scene tree
	add_child(cloud)
