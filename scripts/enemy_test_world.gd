extends Node2D
@export var animation_player: AnimationPlayer
@export var color_rect: ColorRect
@export var transition: Node2D
const SETTINGS_SCENE = preload("res://scenes/settings.tscn")

func _ready() -> void:
	Loader.restart_level.connect(reset)
	start_transition()

func _input(event: InputEvent) -> void:
	if get_tree().paused:
		return
	if event.is_action_pressed("restart"):
		reset()
		end_transition()

func reset():
	Loader.current_palette = 0.0
	Loader.score = 0.0
	#Loader.restart_level.emit()
	var bullets = get_tree().get_nodes_in_group("bullets")
	for bullet in bullets:
		bullet.queue_free()

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
	transition.position.x = -300
	#transition.visible = true
	#animation_player.play("trans_end")
	#await animation_player.animation_finished
	tree.reload_current_scene()

func _on_pause_pressed() -> void:
	var settings = SETTINGS_SCENE.instantiate()
	settings.opened_from_game = true 
	get_tree().paused = true
	get_tree().root.add_child(settings)
	settings.process_mode = Node.PROCESS_MODE_ALWAYS
