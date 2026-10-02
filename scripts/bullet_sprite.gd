extends CharacterBody2D


var Velocity : Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	global_position += Velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited() :
	queue_free()
