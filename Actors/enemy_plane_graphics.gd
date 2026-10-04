extends Node2D

var color_palette = [
	[Color("e7bb6386"), Color("483a20")],
	[Color("dd9ee464"), Color("291f48")],
	[Color.TRANSPARENT, Color.BLACK]
]

func _ready() -> void:
	change_color_palette(Loader.current_palette)
	Loader.change_palette.connect(change_color_palette)


func change_color_palette(i):
	$Sprite2D/overlay.color = color_palette[i][0]
	$shadow/overlay.color = color_palette[i][1]
