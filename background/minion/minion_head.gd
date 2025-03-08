extends CharacterBody3D
var turn_speed = 0.01
var stopped = true
var initial_direction
var initial_direction2
var wanted_direction2
var current_direction = Vector3(0, 0, -1)
var wanted_direction
var current_pos = []
var inactive = false
var rotation_for_hitbox
var speed = 300
var duration = 2
var start = false
var started = false

func _physics_process(delta: float) -> void:
	$Area2D.global_position = Globals.camera.unproject_position(global_position)
	if start == true:
		start = false
		started = true
		begin()
	if inactive == false and stopped == false and started == true:
		stopped = false
		global_position += current_direction * speed * delta
		rotation_for_hitbox =  Vector2(current_direction.z, current_direction.y).angle()
		var wanted_rotation = Basis(Vector3(-1, 0, 0), Vector2(current_direction.z, current_direction.y).angle()) * Basis(Vector3(0, 1, 0), PI)
		transform.basis = wanted_rotation
		move_and_slide()
		current_pos.append(global_position)

func set_direction(t):
	current_direction = initial_direction.lerp(wanted_direction, t).normalized()

func set_direction2(t):
	current_direction = initial_direction2.lerp(wanted_direction2, t).normalized()

func change_direction():
	var tween = create_tween()
	initial_direction = current_direction
	tween.tween_method(set_direction, 0.0, 1.0, duration)

func change_direction2():
	var tween = create_tween()
	initial_direction = current_direction
	initial_direction2 = wanted_direction
	wanted_direction2 = Vector3(initial_direction.x, -1*initial_direction.y, initial_direction.z)
	tween.tween_method(set_direction, 0.0, 1.0, duration)
	tween.tween_method(set_direction2, 0.0, 1.0, duration)
func change_speed(sp):
	speed = sp

func set_speed():
	var tween = create_tween()
	tween.tween_method(change_speed, speed, speed + speed * 1/3, duration)
	
func set_speed2():
	var tween = create_tween()
	tween.set_parallel(false)
	tween.tween_method(change_speed, speed, 150.0, duration)
	tween.tween_method(change_speed, 150.0, speed, duration)

func begin():
	current_pos.append(global_position)
	if get_parent().global_position.z == 300:
		current_direction = Vector3(0, 0, -1)
		wanted_direction = Vector3(0, -1, 0)
		stopped = false
		change_direction()
		set_speed()
	elif get_parent().global_position.z == -300:
		current_direction = Vector3(0, 0, 1)
		wanted_direction = Vector3(0, -1, 0)
		stopped = false
		change_direction()
		set_speed()
	elif get_parent().global_position.z > 0:
		duration = 2
		wanted_direction = Vector3(0, 0, -1).normalized()
		stopped = false
		set_speed2()
		change_direction2()
	else:
		duration = 2
		wanted_direction = Vector3(0, 0, 1).normalized()
		stopped = false
		set_speed2()
		change_direction2()
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if "hit" in body:
		body.hit()
