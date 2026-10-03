extends Node2D

@export var despawn_distance = 1500
var player : CharacterBody2D = Loader.player
@export var enemy : Node2D 

signal despawn

func _process(delta: float) -> void:
	if enemy.global_position.distance_to(player.global_position) >= despawn_distance:
		despawn.emit()
		get_parent().queue_free()
