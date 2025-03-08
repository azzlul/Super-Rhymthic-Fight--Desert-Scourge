extends Node2D
var previous_health = 8
func _ready() -> void:
	Globals.health_change.connect(_on_health_change)

func _on_fade_out_t_imer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property($Sprite2D, "modulate", Color(1, 1, 1, 0), 0.5)
func _on_health_change():
	if previous_health != 0:
		if Globals.health < previous_health:
			$Sprite2D.modulate = Color(1, 1, 1, 0.8)
			$AnimationPlayer.play("damage")
		if Globals.health == 8:
			$FadeOutTImer.start()
		$Sprite2D.frame = 8 - Globals.health
		previous_health = Globals.health
