extends Control
@export var color_rect : ColorRect
@export var touch_screen_button_esc : TouchScreenButton
@export var transition : Node2D
@export var animation_player : AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_transition()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event) -> void:
	if Input.is_action_just_pressed("ui_cancel") or (event is InputEventKey and event.keycode == KEY_BACK and event.pressed):
		end_transition()

func start_transition():
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	transition.position.x = 1042
	animation_player.play("trans_start")
	await animation_player.animation_finished
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	transition.visible = false

func end_transition():
	var tree = get_tree()
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	touch_screen_button_esc.queue_free()
	transition.position.x = -300
	transition.visible = true
	animation_player.play("trans_end")
	await animation_player.animation_finished
	tree.change_scene_to_file("res://Scenes/main_menu.tscn")
