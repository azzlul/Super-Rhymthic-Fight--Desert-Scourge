extends Node2D
@export var length:float = 10000
@export var delay:float = 2
@export var laser_width: float = 10
@export var warning_transition_time: float = 0.5
@export var look_at_player:bool = false
var start_looking: bool = false
var tween
func _ready():
	$Line2D.set_point_position(1,Vector2(length, 0))
	$Timer.wait_time = delay
	$Timer.start()
	tween = create_tween()
	rotation = (Globals.player_pos-global_position).angle()
	$Line2D.width = laser_width
	tween.tween_property($Line2D, "default_color", Color(1, 0, 0, 1), warning_transition_time)
	await get_tree().create_timer(delay - 2*warning_transition_time).timeout
	tween = create_tween()
	start_looking = false
	tween.tween_property($Line2D, "default_color", Color(1, 0, 0, 0), warning_transition_time)	


func _on_timer_timeout():
	queue_free()
