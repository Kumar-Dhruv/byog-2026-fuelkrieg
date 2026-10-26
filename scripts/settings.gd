extends CanvasLayer

@export var animation_player: AnimationPlayer
@export var transition: Node2D
@export var color_rect: TextureRect

@export var MusicIcon : Sprite2D
@export var SFXIcon : Sprite2D
@export var MasterIcon : Sprite2D

@export var MusicSlider : HSlider
@export var SFXSlider : HSlider
@export var MasterSlider : HSlider

var music_mute : bool = false
var sfx_mute : bool = false
var master_mute : bool = false

var last_music_val : float
var last_sfx_val : float
var last_master_val : float

var opened_from_game : bool = false

func _ready():
	layer = 100
	if not opened_from_game:
		start_transition()
	else:
		transition.visible=false

func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0,linear_to_db(value))
	if value !=0 :
		MasterIcon.texture = load("res://Art/SettingsUI/master.png")
		master_mute = false

func _on_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1,linear_to_db(value))
	if value !=0 :
		SFXIcon.texture = load("res://Art/SettingsUI/sound.png")
		sfx_mute = false

func _on_music_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2,linear_to_db(value))
	if value !=0 :
		MusicIcon.texture = load("res://Art/SettingsUI/music.png")
		music_mute = false

func _on_itch_page_pressed() -> void:
	OS.shell_open("https://vntg.itch.io/fuelkrieg")


func _on_playstore_pressed() -> void:
	OS.shell_open("https://play.google.com/store/apps/details?id=com.pixel3d.fuelkrieg&hl=en")


func _on_musicmute_pressed() -> void:
	if not music_mute:
		MusicIcon.texture = load("res://Art/SettingsUI/musicoff.png")
		last_music_val = MusicSlider.value
		MusicSlider.value = 0
		music_mute = true
	else :
		MusicIcon.texture = load("res://Art/SettingsUI/music.png")
		MusicSlider.value = last_music_val
		music_mute = false


func _on_sfxmute_pressed() -> void:
	if not sfx_mute:
		SFXIcon.texture = load("res://Art/SettingsUI/soundoff.png")
		last_sfx_val = SFXSlider.value
		SFXSlider.value = 0
		sfx_mute = true
	else :
		SFXIcon.texture = load("res://Art/SettingsUI/sound.png")
		SFXSlider.value = last_sfx_val
		sfx_mute = false


func _on_mastermute_pressed() -> void:
	if not master_mute:
		MasterIcon.texture = load("res://Art/SettingsUI/masteroff.png")
		last_master_val = MasterSlider.value
		MasterSlider.value = 0
		master_mute = true
	else :
		MasterIcon.texture = load("res://Art/SettingsUI/master.png")
		MasterSlider.value = last_master_val
		master_mute = false


func _on_exit_pressed() -> void:
	if opened_from_game:
		get_viewport().set_input_as_handled()
		hide()
		# timer that keeps running while the tree is paused
		await get_tree().create_timer(0.15, true).timeout
		get_tree().paused = false
		queue_free()
	else:
		end_transition("res://scenes/main_menu.tscn")

func start_transition():
	transition.position.x = 1042
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	transition.visible = true
	animation_player.play("trans_start")
	await animation_player.animation_finished
	color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	transition.visible = false

func end_transition(scene : String):
	var tree=get_tree()
	color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	transition.position.x = -300
	transition.visible = true
	animation_player.play("trans_end")
	await animation_player.animation_finished
	tree.change_scene_to_file(scene)
