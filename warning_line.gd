extends Node2D
@onready var dash_segment = load("res://bullets/dash_segment.tscn")
var target
var speed = 2000
var direction
var time = 0
func _process(_delta: float) -> void:
	if target != null:
		global_position = Globals.camera.unproject_position(target.global_position)



func warn_dash():
	var segment = dash_segment.instantiate()
	segment.speed = speed
	segment.direction = direction
	segment.rotation = direction.angle()
	add_child(segment)
	segment.start()
