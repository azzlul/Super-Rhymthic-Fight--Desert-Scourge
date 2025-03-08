extends Camera3D

@export var shakeStrength: float = 30.0
@export var fade: float = 5.0
var shaking: bool = false
var strength: float = 0.0
var base_pos: Vector3

func apply_shake():
	strength = shakeStrength
func randomOffset():
	return Vector3(0,randf_range(-strength, strength), randf_range(-strength, strength))
func shake():
	shaking = true
func _ready():
	base_pos = position
func _process(delta):
	if shaking:
		apply_shake()
		shaking = false
	if strength > 0:
		strength = lerpf(strength, 0, fade* delta)
		position = base_pos + randomOffset()
