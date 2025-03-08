extends CharacterBody3D

var speed = 1600.0/9
var dash_speed = 16000.0/27
var dash_cooldown = true
var is_dashing = false
var is_cooldown = false
func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
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
	Globals.player_pos_3D = position

func _on_dash_timer_timeout():
	dash_cooldown = true
func _on_dash_lengh_timer_timeout():
	is_dashing = false
