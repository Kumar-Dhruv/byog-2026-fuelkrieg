extends Control

func _ready() -> void:
	Loader.player_died.connect(enable)
func enable():
	visible = true
	$Label3.text = str(Loader.score)
