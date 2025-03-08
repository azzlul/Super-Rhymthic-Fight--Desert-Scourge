extends Node3D


func change_color(color):
	$Sphere.get_surface_override_material(0).emission = color
	$Sphere.get_surface_override_material(1).emission = color
	
func dash_animation():
	var tween = create_tween()
	tween.tween_method(change_color, Color.BLACK, Color.WHITE, 0.5)
	tween.tween_method(change_color, Color.WHITE, Color.BLACK, 0.5)
