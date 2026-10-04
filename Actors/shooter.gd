extends Node2D

var start_shooting_chance = 0.7
var multi_shot_chance = 0.5
var pattern_shot_chance = 0.5
@export var enemy_plane : EnemyPlane
var is_multi_shot = false
var shots_fired = 0
@export var shooting_component : ShootingComponent

func _ready() -> void:
	enemy_plane.set_new_follow_path()
		
func multi_shoot():
	for i in range(3):
		await get_tree().create_timer(shooting_component.time_between_each_shot).timeout
		shooting_component.single_shoot(enemy_plane.plane_forward, enemy_plane.global_position)

func _on_enemy_plane_finished_path() -> void:
	var r = randf()
	if (r <= start_shooting_chance):
		enemy_plane.start_player_follow()
		r = randf()
		if (r <= multi_shot_chance):
			r = randf()
			if (r <= pattern_shot_chance):
				await get_tree().create_timer(shooting_component.time_between_each_shot).timeout
				shooting_component.pattern_shot(enemy_plane.plane_forward, enemy_plane.global_position)
			
			else:
				is_multi_shot = true
				multi_shoot()
				
			
		else:
			await get_tree().create_timer(shooting_component.time_between_each_shot).timeout
			shooting_component.single_shoot(enemy_plane.plane_forward, enemy_plane.global_position)
			
	else:
		enemy_plane.set_new_follow_path()


func _on_enemy_shoot_component_finished_shooting() -> void:
	if is_multi_shot:
		shots_fired += 1
		
		if shots_fired >= 3:
			enemy_plane.set_new_follow_path()
			is_multi_shot = false
	else:
		enemy_plane.set_new_follow_path()

@export var death_fx : PackedScene

func _on_health_component_zero_health() -> void:
	Loader.spawner.decrease_enemy_count()
	
	var d : Node2D = death_fx.instantiate()
	get_tree().root.add_child(d)
	d.start_explosion(enemy_plane.global_position,0, 1.5)
	Loader.score += 150
	get_parent().queue_free()


func _on_despawn_despawn() -> void:
	Loader.spawner.decrease_enemy_count()
