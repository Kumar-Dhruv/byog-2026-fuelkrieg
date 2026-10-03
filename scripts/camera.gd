extends Camera2D
@onready var player_plane: CharacterBody2D = $"../PlayerPlane"
var cam_offset = 350.0 #how far ahead cam can see
var target_offset = Vector2.ZERO #initialising to zero


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	if player_plane.velocity.length()>10.0:
		#player moves -> target offset changes
		target_offset = player_plane.velocity.normalized() * cam_offset
	
	#if moving up/down -> camera fov zooms out and offset increases
	if player_plane.boost_state:
		zoom = zoom.lerp(Vector2(0.5,0.5), 3 * delta) #BOOST
		cam_offset = 350.0
	elif Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		zoom = zoom.lerp(Vector2(0.7,0.7), 3 * delta) #MOVING
		cam_offset = 350.0
	#else :
		#cam_offset = 150.0
		#zoom = zoom.lerp(Vector2(1.15,1.15), 3 * delta) #STILL
	
	#gives camera the target vector to move to
	var target_pos = player_plane.global_position + target_offset
	
	position = position.lerp(target_pos , 5 * delta)
