extends CharacterBody3D
@export var target:CharacterBody3D
var target_pos
var current_pos = []
var inactive = false
var stopped = false
var speed_multiplier = 1
var speed_multiplier_speed = 0.1
var twirl_amount = 0
var distance = 0
var rotation_for_hitbox
var min_distance = 11
var max_distance = 13
var speed
var started = false
var start = true

func set_target(tar):
	target = tar

func _physics_process(delta: float) -> void:
	$Area2D.global_position = Globals.camera.unproject_position(global_position)
	speed = target.speed
	if target.started and start:
		started = true
		current_pos.append(global_position)
		target_pos = target.global_position
		start = false
		
	if not inactive and not target.stopped and target.current_pos != [] and started == true:
		stopped = false
		while global_position.distance_to(target_pos) < speed/50 and target.current_pos != []:
			target_pos = target.current_pos.pop_front()
		calculate_distance()
		var direction = global_position.direction_to(target_pos)
		if distance <= min_distance and speed_multiplier > 0.5:
			speed_multiplier -= speed_multiplier_speed*delta
		elif  min_distance <= distance and distance <= max_distance and speed_multiplier != 1:
			speed_multiplier = 1
		elif distance > max_distance and speed_multiplier < 10:
				speed_multiplier += speed_multiplier_speed*delta
		global_position += speed*direction*delta*speed_multiplier
		rotation_for_hitbox = Vector2(direction.z, direction.y).angle()
		transform.basis = Basis(Vector3(-1, 0, 0), Vector2(direction.z, direction.y).angle()) * Basis(Vector3(0, 1, 0), PI) * Basis(Vector3(0, 0, 1), twirl_amount)
		move_and_slide()
		current_pos.append(global_position)
	else:
		stopped = true

func calculate_distance():
	distance = global_position.distance_to(target_pos)
	if target.current_pos != []:
		distance += target_pos.distance_to(target.current_pos.front())
		for i in range(1, target.current_pos.size()):
			distance += target.current_pos[i-1].distance_to(target.current_pos[i])

func change_rotation_z(val):
	twirl_amount = val
	
	
func twirl():
	var tween = create_tween()
	tween.tween_method(change_rotation_z, 0.0, 2*PI, 1)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if "hit" in body:
		body.hit()
