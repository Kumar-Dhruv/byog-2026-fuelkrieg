extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event) -> void:
	if Input.is_action_just_pressed("ui_cancel") or (event is InputEventKey and event.keycode == KEY_BACK and event.pressed):
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
