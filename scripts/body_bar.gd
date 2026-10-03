extends ProgressBar
@onready var fuel_component = $"../../../PlayerPlane/FuelComponent"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_value = fuel_component.fuel_main.body_fuel


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = fuel_component.fuel_main.body_fuel
	
