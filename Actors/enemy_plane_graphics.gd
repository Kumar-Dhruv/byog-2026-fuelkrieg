extends Node2D

var color_palette = [
	[Color("483a20"), Color("e7bb6386")],
	[Color.TRANSPARENT, Color.BLACK]
]

func change_color_palette(i):
	$Sprite2D/overlay.color = color_palette[i][0]
	$shadow/overlay.color = color_palette[i][1]
