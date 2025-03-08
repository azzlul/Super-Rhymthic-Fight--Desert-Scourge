extends Area2D
@export var delay:float = 2
@export var charge_time:float = 0.2
@export var duration:float = 1
@export var initial_size: float = 1
@export var final_size: float = 10
@export var charge_transition_time: float = 0.1
@export var fire_transition_time: float = 0.1
@export var warning_transition_time: float = 0.5
@export var deactivation_transition_time:float = 0.5
@export var look_at_player:bool = false
@export var warning_rotation_speed: float = 1
@export var hitbox_ratio: float = 0.75
var start_looking: bool = false
var is_delay:bool = true
var is_charging:bool = false
var is_firing:bool = false
var tween
var base_scale:float = 0.3
func _ready():
	$CollisionShape2D.scale = Vector2(0,0)
	$Circle.scale = Vector2(0,0)
	$CollisionShape2D.disabled = true
	$Timers/DelayTimer.wait_time = delay
	$Timers/ChargeTimeTimer.wait_time = charge_time
	$Timers/DurationTimer.wait_time = duration
	$Timers/DelayTimer.start()
	$CircleWarning.scale = Vector2(base_scale,base_scale)*initial_size
	tween = create_tween()
	start_looking = true
	tween.tween_property($CircleWarning, "modulate", Color(1, 1, 1, 1), warning_transition_time)
	await get_tree().create_timer(delay - warning_transition_time).timeout
	start_looking = false
func _process(delta):
	if is_delay:
		$CircleWarning.rotation += warning_rotation_speed*delta
	if is_charging:
		$CircleWarning.visible = false
		$Circle.visible = true
		tween = create_tween().set_parallel()
		tween.tween_property($Circle, "scale", Vector2(base_scale,base_scale)*initial_size, charge_transition_time)
		tween.tween_property($CollisionShape2D, "scale", Vector2(base_scale,base_scale)*initial_size*hitbox_ratio, charge_transition_time)
	elif is_firing:
		$CollisionShape2D.disabled = false
		tween = create_tween().set_parallel()
		tween.tween_property($Circle, "scale", Vector2(base_scale,base_scale)*final_size, fire_transition_time)
		tween.tween_property($CollisionShape2D, "scale", Vector2(base_scale,base_scale)*final_size*hitbox_ratio, fire_transition_time)
	if look_at_player and start_looking:
		position = Globals.player_pos
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
	tween.tween_property($Circle, "scale", Vector2(0,0), deactivation_transition_time)
	await tween.finished
	queue_free()

func _on_body_entered(body):
	if "hit" in body:
		body.hit()
