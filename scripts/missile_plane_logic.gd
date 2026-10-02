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
	if enemy_plane.global_position.distance_to(player.global_position) >= activation_distance:
		attack_timer.stop()
	elif attack_timer.is_stopped():
		attack_timer.start()

func _on_plane_finished_path() -> void:
	enemy_plane.set_new_follow_path()


func _on_attack_timer_timeout() -> void:
	var r = randf()
	if r <= missile_chance:
		shooting_component.missile_shot(enemy_plane.global_position)
	else:
		shooting_component.single_shoot((player.global_position - enemy_plane.global_position).normalized(), enemy_plane.global_position)
