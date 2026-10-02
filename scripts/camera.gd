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
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or player_plane.boost_state:
		zoom = zoom.lerp(Vector2(1,1), 3 * delta)
		cam_offset = 350.0
	elif player_plane.boost_state :
		zoom = zoom.lerp(Vector2(0.95,0.95), 3 * delta)
		cam_offset = 350.0
	else :
		cam_offset = 150.0
		zoom = zoom.lerp(Vector2(1.15,1.15), 3 * delta)
	
	#gives camera the target vector to move to
	var target_pos = player_plane.global_position + target_offset
	
	position = position.lerp(target_pos , 5 * delta)
