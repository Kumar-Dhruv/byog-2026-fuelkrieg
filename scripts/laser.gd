extends Node2D
var laser_scene : PackedScene = preload("res://Scenes/laser.tscn")
@onready var player_plane: CharacterBody2D = $"../PlayerPlane"
var laser = null
@onready var fuel_component: Node2D = $"../PlayerPlane/FuelComponent"

func _process(delta: float) -> void:
	if Input.is_action_pressed("laser") :
		shoot()
		fuel_component.laser_fuel_val(15 * delta)
	else :
		stop_shooting()
	
	#update with player every frame
	if laser != null :
		laser.global_position = player_plane.global_position
		laser.rotation = player_plane.rotation
	
	if fuel_component.fuel_main.laser_fuel<=0 : stop_shooting()
	
func shoot():
	if laser == null and fuel_component.fuel_main.laser_fuel>0:
		laser = laser_scene.instantiate()
		laser.global_position = player_plane.global_position
		laser.rotation = player_plane.rotation
		get_tree().current_scene.add_child(laser)

func stop_shooting():
	if laser != null:
		laser.queue_free()
