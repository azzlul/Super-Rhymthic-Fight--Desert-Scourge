extends Area2D
var speed = 100
var direction = Vector2(1, 0)
var offset:float = 20
var swirl_interval:float = 0.2
var entered_screen: bool = false
func _ready():
	var tween = create_tween()
	tween.set_loops()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_method(tween_y, position.y - offset/2, position.y + offset/2, swirl_interval)
	tween.chain().tween_method(tween_y, position.y + offset/2, position.y - offset/2, swirl_interval)
func tween_y(value):
	position.y = value
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
