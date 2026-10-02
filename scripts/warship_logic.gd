extends Node2D


# 0 - bullet
# 1 - missile
@export var lower : Array[Marker2D]
@export var upper : Array[Marker2D]
@export var bullet_shooter : ShootingComponent 
@export var missile_shooter : ShootingComponent

var time_between_bullets = 0.3
var time_between_missiles = 1
var power_shot_chance = 0.5
var low_bullet_count = 3
var high_bullet_count = 5
var activation_distance = 1000.0
var bullets_to_check

@onready var player : CharacterBody2D = Loader.player

var missile_gun : Marker2D
var bullet_gun : Marker2D

@export var bullet_timer : Timer
@export var missile_timer : Timer

func _ready() -> void:
	missile_gun = lower[1]
	bullet_gun = lower[0]
	
func check_and_switch_guns():
	if global_position.y <= player.global_position.y:
		missile_gun = lower[1]
		bullet_gun = lower[0]
	else:
		missile_gun = upper[1]
		bullet_gun = upper[0]
		
func _process(delta: float) -> void:
	
	if global_position.distance_to(player.global_position) >= activation_distance:
		bullet_timer.stop()
		missile_timer.stop()
		return
	
	else:
		if bullet_timer.is_stopped():
			bullet_timer.start()
			missile_timer.start()
			
	check_and_switch_guns()



func _on_bullet_finished_shooting() -> void:
	pass # Replace with function body.


func _on_missile_timer_timeout() -> void:
	print("missile")
	var r = randf()
	var x = 1
	if r <= power_shot_chance:
		x = 2
	
	for i in range(x):
		await get_tree().create_timer(time_between_missiles).timeout
		missile_shooter.missile_shot(missile_shooter.global_position)
	
	missile_timer.start()


func _on_bullet_timer_timeout() -> void:
	var r = randf()
	var x = low_bullet_count
	if r <= power_shot_chance:
		x = high_bullet_count
		
	for i in range(x):
		await get_tree().create_timer(time_between_bullets).timeout
		bullet_shooter.single_shoot((player.global_position - bullet_gun.global_position).normalized(), bullet_gun.global_position)
	
	
	bullet_timer.start()
