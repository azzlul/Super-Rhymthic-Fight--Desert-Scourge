extends Node3D
var speed = 100
var direction = Vector3(0, 0, -1)
var entered_screen: bool = false
func _physics_process(delta):
	position += speed*direction*delta;
	$Area2D.global_position = Globals.camera.unproject_position(global_position)
	$CPUParticles2D.global_position = Globals.camera.unproject_position(global_position)
	var rotation_angle = Vector2(direction.y, direction.z).angle()
	transform.basis = Basis(Vector3(1, 0, 0), rotation_angle)
	$CPUParticles2D.rotation = -1*rotation_angle
	$Area2D.rotation =  -1*rotation_angle
	


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	if entered_screen:
		queue_free()


func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	entered_screen = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if "hit" in body:
		body.hit()
	queue_free()
