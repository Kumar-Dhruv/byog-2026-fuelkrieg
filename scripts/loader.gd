extends Node

var player : CharacterBody2D
var spawner : EnemySpawner
var fuel_component 



var palette_change_time = 1
signal change_palette(i)
signal player_died
signal restart_level
var current_palette = 0

var score = 0.0

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_BACK and event.pressed:
		restart_level.emit()
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
		# Add your custom logic here
		
		# Example: Change back to a main menu scene
		# get_tree().change_scene_to_file("res://menu.tscn")
