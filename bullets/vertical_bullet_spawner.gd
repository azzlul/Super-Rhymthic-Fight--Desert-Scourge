extends Node2D
const pi = 3.14159265358979
@export var direction: Vector2
@export var speed: int = 200
@export var delay: float = 1
@export var bullet_size: int = 1
@export var count: int = 1
var spawn_cooldown = true
@export var bullet_path: String
@export var look_at_player: bool = false
@export var bullet_type: String 
@export_group("Swirly")
@export var swirly_offset: float = 20
@export var swirly_interval: float = 0.2
@export_group("Beam")
@export var length: float = 10000
@export var beam_delay:float = 0.5
@export var beam_charge_time:float = 0.2
@export var beam_duration:float = 1
@export var beam_charge_width: float = 1
@export var beam_laser_width: float = 10
@export var beam_charge_transition_time: float = 0.1
@export var beam_fire_transition_time: float = 0.1
@export var beam_warning_transition_time: float = 0.5
@export var beam_deactivation_transition_time:float = 0.5
@export_group("")
@export var lower_bound = 20
@export var upper_bound = 1070
@export var auto_fire:bool = false
var direction_angle_offset_total: float = 0
var bullet
func _ready():
	bullet = load(bullet_path)
	$Timer.wait_time = delay
func _physics_process(_delta):
	if spawn_cooldown and auto_fire:
		spawn_cooldown = false
		$Timer.start()
		attack()

func attack():
	for i in range(0, count):
		var object = bullet.instantiate()
		if bullet_type == "beam":
			object.length = length
			object.delay = beam_delay
			object.charge_time = beam_charge_time
			object.duration = beam_duration
			object.charge_width = beam_charge_width
			object.laser_width = beam_laser_width
			object.charge_transition_time = beam_charge_transition_time
			object.fire_transition_time = beam_fire_transition_time
			object.warning_transition_time = beam_warning_transition_time
			object.deactivation_transition_time = beam_deactivation_transition_time
		else:
			object.speed = speed
			if bullet_type == "swirly":
				object.offset = swirly_offset
				object.swirl_interval = swirly_interval
			object.direction = direction
			object.scale = object.scale * bullet_size
		if not look_at_player:
			object.global_position.y = randi_range(lower_bound, upper_bound)
		else:
			object.global_position.y = Globals.player_pos.y
		add_child(object)

func _on_timer_timeout():
	spawn_cooldown = true
