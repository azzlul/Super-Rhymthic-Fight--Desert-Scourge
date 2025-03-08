extends CharacterBody3D

var speed = 1600.0/9
var dash_speed = 16000.0/27
var dash_cooldown = true
var is_dashing = false
var is_cooldown = false
var last_direction: Vector2 = Vector2.RIGHT
var direction: Vector2 = Vector2.RIGHT
var wanted_rotation
func _physics_process(_delta):
	direction = Input.get_vector("left", "right", "up", "down")
	if $Timer/DashLenghTimer.is_stopped():
		velocity = Vector3(0, -direction.y, -direction.x)*speed
		if Input.is_action_pressed("focus"): 
			velocity /= 2
	else:
		velocity = Vector3(0, -direction.y, -direction.x)*dash_speed
	if Input.is_action_just_pressed("dash") and dash_cooldown:
		is_dashing = true
		dash_cooldown = false
		$Timer/DashTimer.start()
		$Timer/DashLenghTimer.start()
	move_and_slide()
	if direction != Vector2.ZERO:
		wanted_rotation = Basis(Vector3(-1, 0, 0), direction.angle()) * Basis(Vector3(0, 1, 0), PI/6)
	else:
		wanted_rotation = Basis(Vector3(-1, 0, 0), last_direction.angle()) * Basis(Vector3(1, 0, 0), direction.angle())
	var x_bound = 2560.0/9
	var y_bound = 160
	if position.z < -x_bound:
		position.z = -x_bound
	if position.z > x_bound:
		position.z = x_bound
	if position.y < -y_bound:
		position.y = -y_bound
	if position.y > y_bound:
		position.y = y_bound
	if direction != Vector2.ZERO:
		last_direction = direction
	$playerModel.transform.basis = Basis(Quaternion($playerModel.transform.basis).slerp(Quaternion(wanted_rotation), 0.15))
	Globals.player_pos_3D = position
	
func _on_dash_timer_timeout():
	dash_cooldown = true
	$playerModel.dash_animation()
	
func hit():
	if Globals.health == 0:
		visible = false
	
func _on_dash_lengh_timer_timeout():
	is_dashing = false
