extends Area2D
@export var length:float = 10000
@export var delay:float = 2
@export var charge_time:float = 0.2
@export var duration:float = 1
@export var charge_width: float = 1
@export var laser_width: float = 10
@export var charge_transition_time: float = 0.1
@export var fire_transition_time: float = 0.1
@export var warning_transition_time: float = 0.5
@export var deactivation_transition_time:float = 0.5
@export var look_at_player:bool = false
var start_looking: bool = false
var is_delay:bool = true
var is_charging:bool = false
var is_firing:bool = false
var tween
func _ready():
	$Line2D.set_point_position(1,Vector2(length, 0))
	$WarningLine.set_point_position(1, Vector2(length, 0))
	$CollisionShape2D.disabled = true
	$CollisionShape2D.shape.size.x = length
	$CollisionShape2D.shape.size.y = 0
	$CollisionShape2D.position = Vector2(length/2, 0)
	$Timers/DelayTimer.wait_time = delay
	$Timers/ChargeTimeTimer.wait_time = charge_time
	$Timers/DurationTimer.wait_time = duration
	$Timers/DelayTimer.start()
	tween = create_tween()
	start_looking = true
	tween.tween_property($WarningLine, "default_color", Color(1, 0, 0, 0.5), warning_transition_time)
	await get_tree().create_timer(delay - 2*warning_transition_time).timeout
	tween = create_tween()
	start_looking = false
	tween.tween_property($WarningLine, "default_color", Color(1, 0, 0, 0), warning_transition_time)	
func _process(_delta):
	if is_charging:
		$WarningLine.visible = false
		tween = create_tween()
		tween.tween_property($Line2D, "width", charge_width, charge_transition_time)
	elif is_firing:
		$CollisionShape2D.disabled = false
		tween = create_tween()
		tween.parallel().tween_property($Line2D, "width", laser_width, fire_transition_time)
		#tween.parallel().tween_method(change_col_witdh, charge_width, laser_width, fire_transition_time)
		$CollisionShape2D.shape.size.y = laser_width
	if look_at_player and start_looking:
		rotation = (Globals.player_pos-global_position).angle()
func change_col_witdh(value):
	$CollisionShape2D.shape.size.y = value
func _on_delay_timer_timeout():
	is_charging = true
	is_delay = false
	$Timers/ChargeTimeTimer.start()


func _on_charge_time_timer_timeout():
	is_charging = false
	is_firing = true
	$Timers/DurationTimer.start()


func _on_duration_timer_timeout():
	is_firing = false
	$CollisionShape2D.disabled = true
	tween = create_tween()
	tween.tween_property($Line2D, "width", 0, deactivation_transition_time)
	await tween.finished
	queue_free()

func _on_body_entered(body):
	if "hit" in body:
		body.hit()
