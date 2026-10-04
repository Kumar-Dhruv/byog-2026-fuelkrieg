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
