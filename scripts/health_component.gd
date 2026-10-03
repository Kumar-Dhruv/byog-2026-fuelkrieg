extends Node2D
@export var max_health = 5
var Health : int

func _ready():
	Health = max_health
	
func damage(dmg):
	Health -= dmg
	
