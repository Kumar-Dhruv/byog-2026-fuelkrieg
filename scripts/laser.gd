extends Node2D
var laser_scene : PackedScene = preload("res://Scenes/laser.tscn")
@onready var player_plane: CharacterBody2D = $"../PlayerPlane"
var laser = null


func _process(delta: float) -> void:
	
	if Input.is_action_pressed("laser"):
		shoot()
	else :
		stop_shooting()
	
	#update with player every frame
	if laser != null :
		laser.global_position = player_plane.global_position
		laser.rotation = player_plane.rotation
	
func shoot():
	if laser == null :
		laser = laser_scene.instantiate()
		laser.global_position = player_plane.global_position
		laser.rotation = player_plane.rotation
		get_tree().current_scene.add_child(laser)
		
func stop_shooting():
	if laser != null:
		laser.queue_free()
