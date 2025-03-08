extends Node3D
var index = 0
var count = 11
var head 
var body
var tail
var previous_body
var head_instance
var instances = []
var isnt_dashing = true
@export var activated = true
func _ready() -> void:
	$addPozTimer.wait_time = 100*0.45/Globals.speed
	head = load("res://background/head.tscn")
	body = load("res://background/body.tscn")
	tail = load("res://background/tail.tscn")
	$addPozTimer.start()

func _on_add_poz_timer_timeout() -> void:
	if activated:
		if index == 0:
			head_instance = head.instantiate()
			add_child(head_instance)
			previous_body = head_instance
			head_instance.inactive = false
			$"../GameElements/Bullets/HeadSpawner".target_body = head_instance
			index+= 1
			instances.append(head_instance)
		elif index < count:
			var body_instance = body.instantiate()
			body_instance.set_target(previous_body)
			add_child(body_instance)
			previous_body = body_instance
			body_instance.inactive = false
			get_node("../GameElements/Bullets/BodySpawner" + str(index)).target_body = body_instance
			index+= 1
			instances.append(body_instance)
		elif index == count:
			var tail_instance = tail.instantiate()
			tail_instance.set_target(previous_body)
			add_child(tail_instance)
			tail_instance.inactive = false
			$"../GameElements/Bullets/TailSpawner".target_body = tail_instance
			index += 1
			instances.append(tail_instance)
		else:
			$addPozTimer.stop()
func set_target(tar):
	if head_instance != null:
		$Head.set_target(tar)

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_T):
		twirl()
	if Input.is_action_just_pressed("worm_long_dash") and isnt_dashing:
		isnt_dashing = false
		await instances[0].start_long_dash()
		twirl()
		isnt_dashing = true
	if Input.is_action_just_pressed("increase_speed"):
		var tween = create_tween()
		tween.tween_method(change_speed, Globals.speed, Globals.speed + 100, 1)
	if Input.is_action_just_pressed("decrease_speed"):
		var tween = create_tween()
		tween.tween_method(change_speed, Globals.speed, Globals.speed - 100, 1)

func twirl():
	for instance in instances:
		instance.twirl()
		await get_tree().create_timer(0.1).timeout

func change_speed(sp):
	Globals.speed = sp

func _on_test_timer_timeout() -> void:
	pass
	
