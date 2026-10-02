extends Node2D
var bullet_sprite : PackedScene = preload("res://Scenes/bullet_sprite.tscn")
@onready var player_plane: CharacterBody2D = $"../PlayerPlane"
var SPEED = 800

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot()
	

func shoot():
	var bullet = bullet_sprite.instantiate()
	bullet.global_position = player_plane.global_position
	bullet.rotation = player_plane.rotation
	
	var facing_dir = Vector2.UP.rotated(player_plane.rotation)
	bullet.Velocity = facing_dir * SPEED
	
	get_tree().current_scene.add_child(bullet)
