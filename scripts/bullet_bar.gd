extends ProgressBar
@onready var fuel_component = Loader.fuel_component


var fill_style

var play_sfx = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fill_style = StyleBoxFlat.new()
	
	fill_style.bg_color = Color("#ff0000c0") 
	max_value = fuel_component.fuel_main.bullet_fuel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fuel_component.gun_is_out :
		if play_sfx:
			AudioManager.stop("low fuel")
			print("stopped")
		queue_free()
	
	else:
		
		if fuel_component.bullet_eject:
			add_theme_stylebox_override("fill", fill_style)
			value -= 10 * delta
			max_value = 100.0
			$Label.visible = false
			$Label2.visible = true
			
			if not play_sfx:
				play_sfx = true
				AudioManager.play("low fuel")
			
		else : 
			value = max_value - fuel_component.fuel_main.bullet_fuel
			
			
		if value == max_value - 100 and fuel_component.bullet_eject:
			if play_sfx:
				AudioManager.stop("low fuel")
				print("stopped")
			fuel_component.destroy_gun()
