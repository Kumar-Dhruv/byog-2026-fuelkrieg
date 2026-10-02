extends Node2D

var start_shooting_chance = 0.7
var multi_shot_chance = 0.5
var pattern_shot_chance = 0.5
var is_pattern_shot = false
@export var enemy_plane : EnemyPlane
var bullet_speed = 500.0
var single_shot_shoot_distance = 450.0
var bullets_to_shoot = 1
var attack_mode = false
var time_between_each_shot = 0.3
var start_shooting = false

@export var bullet_scene : PackedScene


func _ready() -> void:
	enemy_plane.set_new_follow_path()

func _process(delta: float) -> void:
	if attack_mode:
		if (bullets_to_shoot == 1 and (enemy_plane.get_dist_to_player() <= single_shot_shoot_distance)) or bullets_to_shoot > 1:
			shoot_bullets()
			attack_mode = false

func shoot_bullets():
	
	if is_pattern_shot:
		print("pattern")
		await get_tree().create_timer(time_between_each_shot).timeout
		var b1 : CharacterBody2D = bullet_scene.instantiate()
		var b2 : CharacterBody2D = bullet_scene.instantiate()
		var b3 : CharacterBody2D = bullet_scene.instantiate()
		b1.global_position = enemy_plane.global_position
		b1.velocity = enemy_plane.plane_forward.normalized() * bullet_speed
		get_tree().root.add_child(b1)
		b2.global_position = enemy_plane.global_position
		b2.velocity = enemy_plane.plane_forward.rotated(deg_to_rad(5)).normalized() * bullet_speed
		get_tree().root.add_child(b2)
		b3.global_position = enemy_plane.global_position
		b3.velocity = enemy_plane.plane_forward.rotated(deg_to_rad(-5)).normalized() * bullet_speed
		get_tree().root.add_child(b3)
	
	else:
	
		for i in range(bullets_to_shoot):
			await get_tree().create_timer(time_between_each_shot).timeout
			var b : CharacterBody2D = bullet_scene.instantiate()
			b.global_position = enemy_plane.global_position
			b.velocity = enemy_plane.plane_forward.normalized() * bullet_speed
			get_tree().root.add_child(b)
		
		
	is_pattern_shot = false
	enemy_plane.set_new_follow_path()

func _on_enemy_plane_finished_path() -> void:
	var r = randf()
	if (r <= start_shooting_chance):
		enemy_plane.start_player_follow()
		r = randf()
		if (r <= multi_shot_chance):
			bullets_to_shoot = 3
			r = randf()
			if (r <= pattern_shot_chance):
				is_pattern_shot = true
		else:
			bullets_to_shoot = 1
			
		attack_mode = true
	else:
		enemy_plane.set_new_follow_path()
