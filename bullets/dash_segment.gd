extends Node2D
var speed
var direction
var started
func start():
	$AnimationPlayer.play("warning")
	started = true


func _process(delta: float) -> void:
	if started:
		global_position += speed*direction*delta

func die():
	queue_free()
