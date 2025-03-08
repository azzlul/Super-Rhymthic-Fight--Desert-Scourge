extends CharacterBody3D
var turn_speed = 0.01
var stopped = false
var current_direction = Vector3(0, 0, -1)
var current_pos = []
var target = Vector3(0, 0, 1)
var state = Globals.STATE.INNER_PATROL
var inactive = true
var wanted_direction
var twirl_amount = 0
var radius_y = 140
var radius_z = 250
var insta_turn = false
var rotation_for_hitbox
func _ready() -> void:
	$HeadHitBox.target = $"."
	$warning_line.target = $"."
	current_pos.append(global_position)
	
	
func rotate_to_wanted(wanted_direction, delta):
	if !insta_turn:
		var angle = Vector2(current_direction.z, current_direction.y).angle_to(Vector2(wanted_direction.z, wanted_direction.y))
		if angle > 0.1:
			current_direction = current_direction.rotated(Vector3(-1, 0, 0), turn_speed)
			turn_speed += 0.04*delta
		elif angle < -0.1:
			current_direction = current_direction.rotated(Vector3(1, 0, 0), turn_speed)
			turn_speed += 0.04*delta
		else:
			current_direction = wanted_direction
			turn_speed = 0.01
	else:
		current_direction = wanted_direction

func _physics_process(delta: float) -> void:
	if Input.is_key_pressed(KEY_M):
		start_turn()
	if Input.is_key_pressed(KEY_I):
		state = Globals.STATE.INNER_PATROL
		radius_y = 140
		radius_z = 250
	if Input.is_key_pressed(KEY_O):
		state = Globals.STATE.OUTER_PATROL
		radius_y = 300
		radius_z = 500
	if Input.is_key_pressed(KEY_F):
		Globals.speed = 150
		state = Globals.STATE.FOLLOW_PLAYER
	if inactive == false and stopped == false:
		if state == Globals.STATE.INNER_PATROL or state == Globals.STATE.OUTER_PATROL:
			var y = global_position.y
			var z = global_position.z
			if abs((y*y/(radius_y*radius_y) + z*z/(radius_z*radius_z)) - 1) < 1:
				if state == Globals.STATE.OUTER_PATROL:
					Globals.speed = 200
					insta_turn = false
				var point_z = 700
				if y != 0:
					if y > 0:
						point_z *= -1
					var point_y = (1 - point_z*z/(radius_z*radius_z)) * (radius_y*radius_y) / y
					wanted_direction = global_position.direction_to(Vector3(global_position.x, point_y, point_z))
				if y == 0:
					if z < 0:
						wanted_direction = Vector3(0, 1, 0)
					else:
						wanted_direction = Vector3(0, -1, 0)
			elif (y*y/(radius_y*radius_y) + z*z/(radius_z*radius_z)) - 1 < 1:
				wanted_direction = Vector3(0, global_position.y, global_position.z).normalized()
			else:
				wanted_direction = Vector3(0, global_position.y, global_position.z).normalized() * (-1)
		elif state == Globals.STATE.FOLLOW_PLAYER or state == Globals.STATE.TURN:
			wanted_direction = (Vector3(global_position.x, Globals.player_pos_3D.y, Globals.player_pos_3D.z) - global_position).normalized()
		rotate_to_wanted(wanted_direction, delta)
		stopped = false
		global_position += current_direction * Globals.speed * delta
		rotation_for_hitbox =  Vector2(current_direction.z, current_direction.y).angle()
		var wanted_rotation = Basis(Vector3(-1, 0, 0), Vector2(current_direction.z, current_direction.y).angle()) * Basis(Vector3(0, 1, 0), PI) * Basis(Vector3(0, 0, 1), twirl_amount)
		transform.basis = wanted_rotation
		move_and_slide()
		current_pos.append(global_position)
		
		

func start_turn():
	state = Globals.STATE.TURN
	turn_speed = 0.05
	$TurnTimer.start()
func start_dash():
	state = Globals.STATE.DASH
	wanted_direction = (Vector3(global_position.x, Globals.player_pos_3D.y, Globals.player_pos_3D.z) - global_position).normalized()
	var tween = create_tween()
	tween.tween_method(change_speed, 100, 600, 0.5)
	$scourge_head6.bite()
	$DashTimer.start()

func start_long_dash():
	stopped = true
	var direction =global_position.direction_to(Vector3(-60, Globals.player_pos_3D.y, Globals.player_pos_3D.z))
	$warning_line.direction = Vector2(-1*direction.z, -1*direction.y).normalized()
	$warning_line.warn_dash()
	await get_tree().create_timer(1.5).timeout
	wanted_direction =  direction
	stopped = false
	state = Globals.STATE.LONG_DASH
	Globals.speed = 600
	turn_speed = 0.2
	insta_turn = true
	$scourge_head6.bite()
	$LongDashTimer.start()

func _on_dash_timer_timeout() -> void:
	state = Globals.STATE.FOLLOW_PLAYER
	turn_speed = 0.01
	var tween = create_tween()
	tween.tween_method(change_speed, 500, 100, 0.5)
	
	
func change_rotation_z(val):
	twirl_amount = val
	
	
func twirl():
	var tween = create_tween()
	tween.tween_method(change_rotation_z, 0.0, 2*PI, 1)
	
	
func change_speed(sp):
	Globals.speed = sp


func _on_long_dash_timer_timeout() -> void:
	state = Globals.STATE.OUTER_PATROL
	turn_speed = 0.01


func _on_turn_timer_timeout() -> void:
	start_dash()
