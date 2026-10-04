extends Node2D

var visible_time = 0.5
var tail_trails_on = false
var outer_trails_on = false
var inner_trails_on = false

# (overlay, shadow)
var color_palette = [
	[Color("e7bb6386"), Color("483a20")],
	[Color("dd9ee464"), Color("291f48")],
	[Color.TRANSPARENT, Color.BLACK],
]

@onready var player : Player = Loader.player

func _ready() -> void:
	Loader.change_palette.connect(change_color_palette)
	Loader.player_died.connect(disable)

func _process(delta: float) -> void:
	
	global_position = player.global_position
	global_rotation = player.global_rotation
	
	if player.boost_state and not tail_trails_on:
		tail_trails_on = true
		toggle_tail_trails(true)
		toggle_inner_trails(true)
	elif not player.boost_state and tail_trails_on:
		tail_trails_on = false
		toggle_tail_trails(false)
		toggle_inner_trails(false)
		
	if player.input_dir.x and not outer_trails_on:
		outer_trails_on = true
		toggle_outer_trails(true)
		print("trails on")
	elif not player.input_dir.x and outer_trails_on:
		outer_trails_on = false
		toggle_outer_trails(false)
		print("trails off")
		
	#if player.velocity.length() >= player.top_speed and not inner_trails_on:
		#toggle_inner_trails(true)
	#elif not player.velocity.length() >= player.top_speed and inner_trails_on:
		#toggle_inner_trails(false)
		

func change_color_palette(i):
	var tween : Tween = create_tween()
	tween.tween_property($parts/Sprite2D/overlay, "color", color_palette[i][0], Loader.palette_change_time)
	tween.parallel().tween_property($parts/Sprite2D2/overlay, "color", color_palette[i][0], Loader.palette_change_time)
	tween.parallel().tween_property($parts/Sprite2D4/overlay, "color", color_palette[i][0], Loader.palette_change_time)
	tween.parallel().tween_property($parts/Sprite2D3/overlay, "color", color_palette[i][0], Loader.palette_change_time)
	tween.parallel().tween_property($shadow/overlay, "color", color_palette[i][1], Loader.palette_change_time)
	$GPUParticles2D.color = color_palette[i][1] 

func toggle_outer_trails(x):
	var tween : Tween = create_tween()
	var c = Color.WHITE
	if not x:
		c = Color.TRANSPARENT
	tween.tween_property($"outer trails/Line2D", "modulate", c, visible_time)
	tween.parallel().tween_property($"outer trails/Line2D2", "modulate", c, visible_time)
	
func toggle_inner_trails(x):
	var tween : Tween = create_tween()
	var c = Color.WHITE
	if not x:
		c = Color.TRANSPARENT
	tween.tween_property($"inner trails/Line2D", "modulate", c, visible_time)
	tween.parallel().tween_property($"inner trails/Line2D2", "modulate", c, visible_time)

func toggle_tail_trails(x):
	var tween : Tween = create_tween()
	$GPUParticles2D.emitting = x
	var c = Color.WHITE
	if not x:
		c = Color.TRANSPARENT
	tween.tween_property($"tail trails/Line2D", "modulate", c, visible_time)
	tween.parallel().tween_property($"tail trails/Line2D2", "modulate", c, visible_time)

func remove_part(i):
	match i:
		1:#guns
			$parts/Sprite2D.visible = false
		2:#boost
			$parts/Sprite2D2.visible = false
		3:#laser
			$parts/Sprite2D3.visible = false


func disable():
	visible = false
