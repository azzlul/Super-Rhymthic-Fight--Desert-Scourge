extends Node
@onready var minion_left = load("res://background/minion/minion.tscn")
@onready var minion_right = load("res://background/minion/minion_left_facing.tscn")
@onready var minion_down = load("res://background/minion/minion_upwards_facing.tscn")
@export var speed_min = 250 
@export var speed_max = 350
@export var direction_min = Vector3(0, 3, 0.5)
@export var direction_max = Vector3(0, 0.8, 1)
@export var poz_bounds_y = 70
@export var poz_bounds_z = 280 
@export var activated = true
func _ready() -> void:
	direction_min = direction_min.normalized()
	direction_max = direction_max.normalized()

func _on_timer_timeout() -> void:
	if activated == true:
		var type = randi_range(1, 4)
		var instance
		if type == 1:
			instance = minion_left.instantiate()
			instance.get_child(0).speed = randi_range(speed_min, speed_max)
			add_child(instance)
			instance.global_position = Vector3(-60, randf_range(-poz_bounds_y, poz_bounds_y), 300)
		elif type == 2:
			instance = minion_right.instantiate()
			instance.get_child(0).speed = randi_range(speed_min, speed_max)
			add_child(instance)
			instance.global_position = Vector3(-60, randf_range(-poz_bounds_y, poz_bounds_y), -300)
		else:
			instance = minion_down.instantiate()
			var poz_z =  randf_range(-poz_bounds_z, poz_bounds_z)
			if poz_z < 0:
				instance.get_child(0).current_direction = direction_min.lerp(direction_max, randf_range(0, 1))
			else:
				var new_min = Vector3(direction_min.x, direction_min.y, -1*direction_min.z)
				var new_max = Vector3(direction_max.x, direction_max.y, -1*direction_max.z)
				instance.get_child(0).current_direction = new_min.lerp(new_max, randf_range(0, 1))
			instance.get_child(0).speed = randi_range(speed_min, speed_max)
			add_child(instance)
			instance.global_position = Vector3(-60, -170, poz_z)
		instance.get_child(0).start = true
