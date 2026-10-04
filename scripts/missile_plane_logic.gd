extends Node2D

var activation_distance = 500.0
var missile_chance = 0.3
@export var enemy_plane : EnemyPlane 
@export var attack_timer : Timer
@onready var player : CharacterBody2D = Loader.player
@export var shooting_component : ShootingComponent

func _ready() -> void:
	enemy_plane.set_new_follow_path()
	
func _process(delta: float) -> void:
	if enemy_plane :
		if enemy_plane.global_position.distance_to(player.global_position) >= activation_distance:
			attack_timer.stop()
		elif attack_timer.is_stopped():
			attack_timer.start()

func _on_plane_finished_path() -> void:
	enemy_plane.set_new_follow_path()


func _on_attack_timer_timeout() -> void:
	var r = randf()
	if enemy_plane :
		if r <= missile_chance:
			shooting_component.missile_shot(enemy_plane.global_position)
		else:
			shooting_component.single_shoot((player.global_position - enemy_plane.global_position).normalized(), enemy_plane.global_position)

@export var death_fx : PackedScene

func _on_health_component_zero_health() -> void:
	Loader.spawner.decrease_enemy_count()
	
	for i in range(3):
		var d : Node2D = death_fx.instantiate()
		get_tree().root.add_child(d)
		d.start_explosion(enemy_plane.global_position, 10.0, 2)
		await get_tree().create_timer(0.2).timeout 
	
	Loader.score += 250
	get_parent().queue_free()


func _on_despawn_despawn() -> void:
	Loader.spawner.decrease_enemy_count()
