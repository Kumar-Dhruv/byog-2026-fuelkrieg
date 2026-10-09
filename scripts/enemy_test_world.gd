extends Node2D

func _ready() -> void:
	Loader.restart_level.connect(reset)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("restart"):
		reset()
		get_tree().reload_current_scene()

func reset():
	Loader.current_palette = 0.0
	Loader.score = 0.0
	#Loader.restart_level.emit()
	var bullets = get_tree().get_nodes_in_group("bullets")
	for bullet in bullets:
		bullet.queue_free()
