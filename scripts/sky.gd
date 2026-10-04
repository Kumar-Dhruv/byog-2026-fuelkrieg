extends CanvasLayer

var color_palette = [
	Color("f4e4c2"),
	Color("291f48"),
	Color("7c000d"),
]

var current_sky = 0;

func _ready() -> void:
	change_sky_color(0)
	

func change_sky_color(i):
	var tween : Tween = create_tween()
	tween.tween_property($sky, "color", color_palette[i], Loader.palette_change_time)
	#$sky.color = color_palette[i]

func _on_timer_timeout() -> void:
	current_sky += 1
	if current_sky == color_palette.size():
		current_sky = 0
		
	change_sky_color(current_sky)
	Loader.change_palette.emit(current_sky)
	Loader.current_palette = current_sky
