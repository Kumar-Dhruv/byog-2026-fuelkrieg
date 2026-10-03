extends Node2D
@export var fuel_main : FuelResource
@onready var player_plane: Player = Loader.player
var bullet_eject : bool = false
var laser_eject : bool = false
var boost_eject : bool = false
var boost_is_out : bool = false
var laser_is_out : bool = false
var gun_is_out : bool = false
var boost_destroy = false
var gun_destroy = false
var laser_destroy = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Loader.fuel_component = self
	fuel_main.body_fuel = 100.0
	fuel_main.boost_fuel = 100.0
	fuel_main.laser_fuel = 100.0
	fuel_main.bullet_fuel = 100.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	boost_fuel_val()
	fuel_main.body_fuel -= 0.2  * delta
	fuel_main.boost_fuel -= 0.2  *  delta
	fuel_main.laser_fuel -= 0.2  *  delta
	fuel_main.bullet_fuel -= 0.2  *  delta

func boost_fuel_val(delta = get_physics_process_delta_time()):
	if player_plane.boost_state:
		if fuel_main.boost_fuel > 0: 
			fuel_main.boost_fuel -= 5 * delta
		else : 
			fuel_main.boost_fuel =0
			if not boost_eject :
				fuel_main.body_fuel -= 20
				boost_eject = true
	
	if fuel_main.boost_fuel <= 0:
		player_plane.can_boost = false

func bullet_fuel_val():
	if fuel_main.bullet_fuel>0 : 
		fuel_main.bullet_fuel -= 1
	else : 
		fuel_main.bullet_fuel = 0
		if not bullet_eject :
			fuel_main.body_fuel -= 20
			bullet_eject = true

func laser_fuel_val(x):
	if fuel_main.laser_fuel>0 : 
		fuel_main.laser_fuel -= x
	else : 
		fuel_main.laser_fuel = 0
		if not laser_eject :
			fuel_main.body_fuel -= 20
			laser_eject = true

func destroy_boost():
	boost_destroy = true
func destroy_gun():
	gun_destroy = true
func destroy_laser():
	laser_destroy = true
