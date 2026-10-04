extends Node2D

var color_palette = [
	Color("423b30"),
	Color("dd9ee4"),
	Color.BLACK
]

func _ready() -> void:
	change_color_palette(Loader.current_palette)

func change_color_palette(i):
	$Sprite2D/ColorRect.color = color_palette[i]

func start_explosion(pos : Vector2, max_offset, s=1):
	global_position = pos
	$Sprite2D.offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * max_offset
	$Sprite2D.scale *= s
	$Sprite2D.play(str(randi_range(1, 3)))
	AudioManager.play("explosion")

func _on_sprite_2d_animation_finished() -> void:
	queue_free()
