extends Area2D
var speed = 100
var direction = Vector2(1, 0)
var entered_screen: bool = false
func _physics_process(delta):
	position += speed*direction*delta;


func _on_body_entered(body):
	if "hit" in body:
		body.hit()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if entered_screen:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	entered_screen = true
