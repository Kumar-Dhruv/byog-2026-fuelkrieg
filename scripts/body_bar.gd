extends ProgressBar
@onready var fuel_component = Loader.fuel_component
@export var overlay : ColorRect

var color_palette = [
	Color("e4bd6a2e"),
	Color("d45eff2e"),
	Color.TRANSPARENT
]

func change_color_palette(i):
	overlay.color = color_palette[i]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_value = fuel_component.fuel_main.body_fuel
	Loader.change_palette.connect(change_color_palette)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	value = max_value - fuel_component.fuel_main.body_fuel
	
