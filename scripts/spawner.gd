extends Node2D
class_name EnemySpawner
@export var kamikaze : PackedScene
@export var bullet : PackedScene
@export var missile : PackedScene

var total_enemy_cap = 5
@export var spawn_radius = 1000.0

@onready var player : CharacterBody2D = Loader.player
var enemy_count = 0.0
var in_late_game = false

var early_game_spawn_rate = [5, 8, 15]
var late_game_spawn_rate = [3, 7, 12]

func _ready() -> void:
	Loader.spawner = self
	$kamikaze.wait_time = early_game_spawn_rate[0]
	$kamikaze.start()
	$bullet.wait_time = early_game_spawn_rate[1]
	$bullet.start()
	$missile.wait_time = early_game_spawn_rate[2]
	$missile.start()
	

func decrease_enemy_count():
	enemy_count -= 1
	
	if enemy_count < 0:
		enemy_count = 0.0
	
	print(enemy_count)

func _on_timer_timeout() -> void:
	$kamikaze.wait_time = late_game_spawn_rate[0]
	$bullet.wait_time = late_game_spawn_rate[1]
	$missile.wait_time = late_game_spawn_rate[2]
	total_enemy_cap += 2
	print("late game")

func spawn_plane(plane_scene : PackedScene):
	if enemy_count >= total_enemy_cap:
		return
		
	var p : Node2D = plane_scene.instantiate()
	var r = deg_to_rad(randi_range(0, 360))
	var spawn_pos = Vector2(player.global_position.x + spawn_radius * cos(r), player.global_position.y + spawn_radius * sin(r))
	p.global_position = spawn_pos
	add_child(p)
	enemy_count += 1
	print(enemy_count)
	
func _on_kamikaze_timeout() -> void:
	spawn_plane(kamikaze)


func _on_bullet_timeout() -> void:
	spawn_plane(bullet)


func _on_missile_timeout() -> void:
	spawn_plane(missile)
