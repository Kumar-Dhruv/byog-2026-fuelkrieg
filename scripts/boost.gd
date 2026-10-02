extends Node2D
@onready var player_plane: CharacterBody2D = $"../PlayerPlane"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		player_plane.boost_state = true
	else:
		player_plane.boost_state = false
