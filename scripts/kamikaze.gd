extends Node2D

var start_player_follow_chance = 0.3

@export var enemy_plane : EnemyPlane


func _ready() -> void:
	enemy_plane.set_new_follow_path()


func _on_enemy_plane_finished_path() -> void:
	var r = randf()
	if (r <= start_player_follow_chance):
		enemy_plane.start_player_follow()
		$"max player follow time".start()
	else:
		enemy_plane.set_new_follow_path()


func _on_max_player_follow_time_timeout() -> void:
	enemy_plane.set_new_follow_path()

@export var death_fx : PackedScene

func _on_health_component_zero_health() -> void:
	Loader.spawner.decrease_enemy_count()
	var d : Node2D = death_fx.instantiate()
	get_tree().root.add_child(d)
	d.start_explosion(enemy_plane.global_position, 0, 1)
	get_parent().queue_free()


func _on_despawn_despawn() -> void:
	Loader.spawner.decrease_enemy_count()
