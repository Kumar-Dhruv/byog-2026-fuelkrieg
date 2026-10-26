extends Control
@export var animation_player: AnimationPlayer
@export var transition: Node2D
@export var color_rect: TextureRect
@export var touch_screen_button_play: TouchScreenButton
@export var touch_screen_button_help: TouchScreenButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_transition()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	end_transition("res://Scenes/enemy_test_world.tscn")

func _on_help_pressed() -> void:
	end_transition("res://Scenes/how_to_play.tscn")

func _on_settings_pressed() -> void:
	end_transition("res://Scenes/settings.tscn")

func start_transition():
	transition.position.x = 1042
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	animation_player.play("trans_start")
	await animation_player.animation_finished
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	transition.visible = false

func end_transition(scene : String):
	var tree=get_tree()
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	touch_screen_button_play.queue_free()
	touch_screen_button_help.queue_free()
	transition.position.x = -300
	transition.visible = true
	animation_player.play("trans_end")
	await animation_player.animation_finished
	tree.change_scene_to_file(scene)
