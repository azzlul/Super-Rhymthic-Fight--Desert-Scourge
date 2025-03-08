extends Node
var groundPath = ["res://background/grounds/ground_1.tscn",
					"res://background/grounds/ground_2.tscn",
					"res://background/grounds/ground_3.tscn",
					"res://background/grounds/ground_4.tscn"]
var grounds = []
var firstGroundX = 30
var firstGroundY = -27.546
var firstGroundZ = 2.637 
var groundNrX = 7
var groundNrY = 5
var distanceBetweenGrounds = 69
var groundScaleFactor = 1.5
var time = 1.3
var wait_time = 1.3
var speed = 80:
	set(value):
		wait_time = 1.3 * 80 / value
		Globals.groundSpeed = value
		speed = value
var rng = RandomNumberGenerator.new()
func spawnGround():
	rng = RandomNumberGenerator.new()
	var ground = grounds[rng.randi()%grounds.size()]
	return ground.instantiate()
func spawnGrounds():
	for ground in groundPath:
		grounds.append(load(ground))
	for j in range(0, groundNrY):
		var offset = rng.randf_range(0, 69)
		for i in range(-groundNrX/2, groundNrX/2+1):
			var ground = spawnGround()
			ground.position = (Vector3(firstGroundX - j*distanceBetweenGrounds*groundScaleFactor, 
										firstGroundY, 
										firstGroundZ - i*distanceBetweenGrounds*groundScaleFactor + offset))
			ground.scale = groundScaleFactor*ground.scale
			ground.rotation = Vector3(0, PI/2 + PI * ((i+j)%2), 0)
			$"../Viewports/SubViewportContainer/SubViewport".add_child(ground)
func spawnNextRow():
	var offset = rng.randf_range(0, 65)
	for i in range(-groundNrX/2, groundNrX/2+1):
		var ground = spawnGround()
		ground.position = (Vector3(firstGroundX - groundNrY*distanceBetweenGrounds*groundScaleFactor, 
									firstGroundY, 
									firstGroundZ - i*distanceBetweenGrounds*groundScaleFactor + offset))
		ground.scale = groundScaleFactor*ground.scale
		ground.rotation = Vector3(0, PI/2 + PI * ((i+groundNrY)%2), 0)
		$"../Viewports/SubViewportContainer/SubViewport".add_child(ground)
func _ready() -> void:
	$GroundSpawnTimer.wait_time = 1.3 * 80 / speed
	spawnGrounds()
func _process(delta: float) -> void:
	if Globals.started:
		time += delta
		if time > wait_time:
			time -= wait_time
			spawnNextRow()
		for ground in $"../Viewports/SubViewportContainer/SubViewport".get_tree().get_nodes_in_group("Ground"):
			ground.start_timer()

func _on_ground_spawn_timer_timeout() -> void:
	spawnNextRow()
