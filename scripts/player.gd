extends Node2D
#@onready var player : Player = Loader.player
@export var death_fx : PackedScene
func _on_health_component_zero_health() -> void:
	Loader.player_died.emit()
	for i in range(5):
		var d : Node2D = death_fx.instantiate()
		get_tree().root.add_child(d)
		d.start_explosion($PlayerPlane.global_position, 10.0, 2.5)
		await get_tree().create_timer(0.2).timeout 
