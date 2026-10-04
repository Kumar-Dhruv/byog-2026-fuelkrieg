extends TextureButton

var tween: Tween

func _ready() -> void:
	call_deferred("setup_pivot")
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func setup_pivot() -> void:
	pivot_offset = size / 2.0

func _on_mouse_entered() -> void:
	set_modulate("#FFD700")
	$Sprite2D.visible = true
	if tween:
		tween.kill() # Stop any current animation to prevent glitching
	
	tween = create_tween()
	# Grow to 115% size over 0.1 seconds
	tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.2).set_trans(Tween.TRANS_SINE)
	
func _on_mouse_exited() -> void:
	set_modulate("#ffffff")
	$Sprite2D.visible = false
	if tween:
		tween.kill()
		
	tween = create_tween()
	# Shrink back to 100% normal size over 0.1 seconds
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.2).set_trans(Tween.TRANS_SINE)
	
