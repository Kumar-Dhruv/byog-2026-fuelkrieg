extends Node2D
var bullet_sprite : PackedScene = preload("res://Scenes/bullet_sprite.tscn")
@onready var player_plane: CharacterBody2D = $"../PlayerPlane"
var SPEED = 800
var can_shoot : bool = true
@onready var fuel_component = Loader.fuel_component


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()

func shoot():
	can_shoot = false
	fuel_component.bullet_fuel_val()
	if fuel_component.fuel_main.bullet_fuel>0:
		var bullet = bullet_sprite.instantiate()
		bullet.global_position = player_plane.global_position
		bullet.rotation = player_plane.rotation
		
		var facing_dir = Vector2.UP.rotated(player_plane.rotation)
		bullet.Velocity = facing_dir * SPEED
		
		get_tree().current_scene.add_child(bullet)
	
	await get_tree().create_timer(0.2).timeout
	can_shoot = true
