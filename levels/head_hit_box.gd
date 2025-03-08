extends Area2D
var target

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if target != null:
		global_position =  Globals.camera.unproject_position(target.global_position)
		if target.rotation_for_hitbox != null:
			rotation = target.rotation_for_hitbox


func _on_body_entered(body: Node2D) -> void:
	if "hit" in body:
		body.hit()
