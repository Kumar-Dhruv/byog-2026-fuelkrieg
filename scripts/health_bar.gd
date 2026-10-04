extends ProgressBar

@export var health_component : Node2D

func _ready() -> void:
	max_value = health_component.max_health

func _process(delta: float) -> void:
	value = health_component.Health
