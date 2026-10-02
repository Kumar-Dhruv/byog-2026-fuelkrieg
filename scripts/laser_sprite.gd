extends CharacterBody2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var colshape: CollisionShape2D = $CollisionShape2D
var length_inc = 40

func _ready():
	#prevent further collision shapes to have same position
	colshape.shape = colshape.shape.duplicate()
	colshape.position.y = -(colshape.shape.size.y / 2.0)

func _physics_process(delta: float) -> void:
	#resizing the sprite
	var texture_height = sprite.texture.get_height()
	sprite.scale.y += length_inc/texture_height
	
	#resizing collision shape
	colshape.shape.size.y += length_inc/2
	colshape.position.y = -(colshape.shape.size.y/2)
