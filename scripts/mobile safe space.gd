extends MarginContainer

func _ready():
	var safe_area = DisplayServer.get_display_safe_area()
	var screen_size = DisplayServer.screen_get_size()

	# Set margins dynamically relative to the screen dimensions
	add_theme_constant_override("margin_left", safe_area.position.x)
	add_theme_constant_override("margin_top", safe_area.position.y)
	add_theme_constant_override("margin_right", screen_size.x - safe_area.end.x)
	add_theme_constant_override("margin_bottom", screen_size.y - safe_area.end.y)
