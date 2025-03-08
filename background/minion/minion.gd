extends Node3D
var index = 0
var count = 4
var head 
var body
var tail
var previous_body
var head_instance
var instances = []
func _ready() -> void:
	#$addPozTimer.wait_time = 100*0.45/Globals.speed
	head = load("res://background/minion/minion_head.tscn")
	body = load("res://background/minion/minion_body.tscn")
	tail = load("res://background/minion/minion_tail.tscn")
	#$addPozTimer.start()

func _on_add_poz_timer_timeout() -> void:
	if index == 0:
		head_instance = head.instantiate()
		add_child(head_instance)
		previous_body = head_instance
		head_instance.inactive = false
		index+= 1
		instances.append(head_instance)
	elif index < count:
		var body_instance = body.instantiate()
		body_instance.set_target(previous_body)
		add_child(body_instance)
		previous_body = body_instance
		body_instance.inactive = false
		index+= 1
		instances.append(body_instance)
	elif index == count:
		var tail_instance = tail.instantiate()
		tail_instance.set_target(previous_body)
		add_child(tail_instance)
		tail_instance.inactive = false
		index += 1
		instances.append(tail_instance)
	else:
		$addPozTimer.stop()
func set_target(tar):
	if head_instance != null:
		$Head.set_target(tar)


func change_speed(sp):
	Globals.speed = sp

func _on_test_timer_timeout() -> void:
	pass
	


func _on_timer_timeout() -> void:
	queue_free()
