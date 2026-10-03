extends Node2D
@export var max_health = 5
var Health : int
var died = false

signal zero_health

func _ready():
	Health = max_health
	
func damage(dmg):
	Health -= dmg
	if not died and Health <= 0:
		zero_health.emit()
		died = true
	
