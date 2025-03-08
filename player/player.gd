extends CharacterBody2D

var speed = 600
var dash_speed = 2000
var dash_cooldown = true
var is_dashing = false
var is_cooldown = false
var last_direction: Vector2 = Vector2.RIGHT
@export var invincible = true
@export var player3D: CharacterBody3D
func _ready():
	$PlayerCooldownMask.visible = false
func _process(_delta):
	Globals.player_pos = global_position
func _physics_process(_delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	if $Timer/DashLenghTimer.is_stopped():
		velocity = direction*speed
		if Input.is_action_pressed("focus"): 
			velocity /= 2
	else:
		if direction != Vector2.ZERO:
			velocity = direction*dash_speed
		else:
			velocity = last_direction*dash_speed
	if Input.is_action_just_pressed("dash") and dash_cooldown:
		is_dashing = true
		dash_cooldown = false
		$Timer/DashTimer.start()
		$Timer/DashLenghTimer.start()
	move_and_slide()
	if direction != Vector2.ZERO:
		rotation = direction.angle()
	else:
		rotation = last_direction.angle()
	if position.x < 0:
		position.x = 0
	if position.x > 1920:
		position.x = 1920
	if position.y < 0:
		position.y = 0
	if position.y > 1080:
		position.y = 1080
	if direction != Vector2.ZERO:
		last_direction = direction


func _on_dash_timer_timeout():
	dash_cooldown = true
func hit():
	if not is_dashing and not is_cooldown and not invincible:
		Globals.health -= 1
		$Timer/SelfHealTimer.start()
		$Timer/DamageTimer.start()
		is_cooldown = true
		player3D.hit()


func _on_self_heal_timer_timeout():
	Globals.health += 1


func _on_dash_lengh_timer_timeout():
	is_dashing = false


func _on_damage_timer_timeout():
	is_cooldown = false
