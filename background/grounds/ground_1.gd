extends Node3D

var is_moving = false
func start_timer():
	$DeleteTimer.wait_time = 10
	if $DeleteTimer.is_stopped():
		$DeleteTimer.start()
	is_moving = true
func _on_delete_timer_timeout() -> void:
	queue_free()
func _process(delta: float) -> void:
	if is_moving:
		position.x += Globals.groundSpeed * delta
