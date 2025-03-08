extends Node3D
@export var scourge: Node3D
var axis_y = 150
var axis_z = 300
var speed = 1
var radius = 0
var speed_outside_multiplier = 1
func set_radius_inside():
	axis_y = 150
	axis_z = 300
	speed_outside_multiplier = 1
func set_radius_outside():
	axis_y = 350
	axis_z = 450
	speed_outside_multiplier = 0.5

func _physics_process(delta: float) -> void:
	speed = 0.5*Globals.speed/100 * speed_outside_multiplier
	scourge.set_target(position)
	position.y = axis_y *sin(radius)
	position.z = axis_z *cos(radius)
	radius += speed*delta
	if radius > 2*PI:
		radius = 0
	if Input.is_key_pressed(KEY_I):
		set_radius_inside()
	if Input.is_key_pressed(KEY_O):
		set_radius_outside()

	
