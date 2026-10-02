extends Node2D

class_name ShootingComponent

var start_shooting_chance = 0.7
var multi_shot_chance = 0.5
var pattern_shot_chance = 0.5
var bullet_speed = 500.0
var single_shot_shoot_distance = 450.0
var bullets_to_shoot = 1
var time_between_each_shot = 0.3
@export var bullet_scene : PackedScene
@export var missile_scene : PackedScene

signal finished_shooting

func single_shoot(dir, pos):
	#await get_tree().create_timer(time_between_each_shot).timeout
	var b : CharacterBody2D = bullet_scene.instantiate()
	b.global_position = pos
	b.velocity = dir * bullet_speed
	get_tree().root.add_child(b)
	finished_shooting.emit()

func pattern_shot(dir, pos):
	#await get_tree().create_timer(time_between_each_shot).timeout
	var b1 : CharacterBody2D = bullet_scene.instantiate()
	var b2 : CharacterBody2D = bullet_scene.instantiate()
	var b3 : CharacterBody2D = bullet_scene.instantiate()
	b1.global_position = pos
	b1.velocity = dir * bullet_speed
	get_tree().root.add_child(b1)
	b2.global_position = pos
	b2.velocity = dir.rotated(deg_to_rad(5)).normalized() * bullet_speed
	get_tree().root.add_child(b2)
	b3.global_position = pos
	b3.velocity = dir.rotated(deg_to_rad(-5)).normalized() * bullet_speed
	get_tree().root.add_child(b3)
	finished_shooting.emit()

func missile_shot(pos):
	var b : CharacterBody2D = missile_scene.instantiate()
	b.global_position = pos
	get_tree().root.add_child(b)
	finished_shooting.emit()
	
