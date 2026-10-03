extends ProgressBar
@onready var fuel_component = Loader.fuel_component


var fill_style

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fill_style = StyleBoxFlat.new()
	
	fill_style.bg_color = Color("#ff0000c0") 
	max_value = fuel_component.fuel_main.laser_fuel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fuel_component.laser_is_out :
		value = 0.0
	
	else:
		if fuel_component.laser_eject :
			add_theme_stylebox_override("fill", fill_style)
			value += 10 * delta
			max_value = 100.0
		else : 
			value = fuel_component.fuel_main.laser_fuel
		if value == 100 and fuel_component.laser_eject:
			fuel_component.destroy_laser()
