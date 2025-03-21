extends Node2D
@export var animation_start_time:float = 0
@export var time_multiplier: float = 1
var game_over_screen_appeared: bool = false
var audio_time:float = 0
var state = 1
var normal_sky_color_1 = Color("4f98ff")
var normal_sky_color_2 = Color("82b6ff")
@onready var scourge_bullets = [$Viewports/SubViewportContainer/SubViewport/GameElements/Bullets/HeadSpawner, $Viewports/SubViewportContainer/SubViewport/GameElements/Bullets/BodySpawner1, $Viewports/SubViewportContainer/SubViewport/GameElements/Bullets/BodySpawner2, $Viewports/SubViewportContainer/SubViewport/GameElements/Bullets/BodySpawner3, $Viewports/SubViewportContainer/SubViewport/GameElements/Bullets/BodySpawner4, $Viewports/SubViewportContainer/SubViewport/GameElements/Bullets/BodySpawner5, $Viewports/SubViewportContainer/SubViewport/GameElements/Bullets/BodySpawner6, $Viewports/SubViewportContainer/SubViewport/GameElements/Bullets/BodySpawner7, $Viewports/SubViewportContainer/SubViewport/GameElements/Bullets/BodySpawner8, $Viewports/SubViewportContainer/SubViewport/GameElements/Bullets/BodySpawner9, $Viewports/SubViewportContainer/SubViewport/GameElements/Bullets/BodySpawner10, $Viewports/SubViewportContainer/SubViewport/GameElements/Bullets/TailSpawner]

var transition_time = 1.0
@export var sky_storm_color_1:Color
@export var sky_storm_color_2:Color
@export var exposure:float = 0.1
func _ready() -> void:
	Globals.camera = $Viewports/SubViewportContainer2/SubViewport2/Camera3D

func menu():
	Globals.health_change.connect(_on_health_change)
	$UI/UI_Above_Player/WarningText.visible = false
	$Viewports/SubViewportContainer/SubViewport/Player.visible = true
	Globals.main_menu = true
	$"UI/UI_Above_Player/main menu".visible = true
	$UI/UI_Below_Player/HSlider.visible = true
func begin():
	Globals.health_change.connect(_on_health_change)
	$UI/UI_Above_Player/WarningText.visible = false
	#$Viewports/SubViewportContainer/SubViewport/Player.visible = true
	Globals.main_menu = true
	$"UI/UI_Above_Player/main menu".visible = true
	$UI/UI_Below_Player/HSlider.visible = true
func _process(_delta):
	if Input.is_action_just_pressed("activate_storm"):
		change_level_state_2()
	if Input.is_action_just_pressed("activate_worm"):
		$Viewports/SubViewportContainer/SubViewport/DesertScourge.activated = !$Viewports/SubViewportContainer/SubViewport/DesertScourge.activated
	if Input.is_action_just_pressed("activate_bullets"):
		for spawner in scourge_bullets:
			spawner.auto_fire = !spawner.auto_fire
	if Input.is_action_just_pressed("activate_minions"):
		$Viewports/SubViewportContainer/SubViewport/GameElements/Bullets/minion_spawner.activated = !$Viewports/SubViewportContainer/SubViewport/GameElements/Bullets/minion_spawner.activated
	$AudioAnimation/AudioStreamPlayer.volume_db = linear_to_db($"UI/UI_Below_Player/HSlider".value)
	if Globals.insta_menu:
		menu()
		$"UI/UI_Above_Player/main menu/CheckButton".button_pressed = Globals.is_infinite
		$UI/UI_Below_Player/HSlider.value = Globals.music_value
		Globals.damage_counter = 0
		Globals.health = 8
		Globals.insta_menu = false
		$Viewports/SubViewportContainer/SubViewport/GameElements/Bullets.visible = true
		$UI/UI_Below_Player/health_bar.visible = false
	if Globals.insta_start:
		
		Globals.health_change.connect(_on_health_change)
		$UI/UI_Below_Player/health_bar.visible = true
		$Viewports/SubViewportContainer/SubViewport/GameElements/Bullets.visible = true
		$"UI/UI_Above_Player/main menu/CheckButton".button_pressed = Globals.is_infinite
		$UI/UI_Below_Player/HSlider.value = Globals.music_value
		Globals.damage_counter = 0
		Globals.health = 8
		get_tree().paused = false
		Globals.insta_start = false
		$UI/UI_Above_Player/WarningText.visible = false
		$Viewports/SubViewportContainer/SubViewport/Player.visible = true
		$AudioAnimation/AnimationPlayer.play("Level")
		$AudioAnimation/AnimationPlayer.seek(animation_start_time)
		$AudioAnimation/AudioStreamPlayer.play(animation_start_time)
		Engine.set_time_scale(time_multiplier)
		$AudioAnimation/AudioStreamPlayer.pitch_scale = time_multiplier
		Globals.pausable = true
	elif Input.is_action_just_pressed("begin") and not Globals.main_menu and not Globals.started:
		begin()
	elif (Input.is_action_just_pressed("begin") and not Globals.started):
		$UI/UI_Below_Player/health_bar.visible = true
		Globals.damage_counter = 0
		Globals.health = 8
		Globals.pausable = true
		$Viewports/SubViewportContainer/SubViewport/GameElements/Bullets.visible = true
		clear_bullets()
		$AudioAnimation/AnimationPlayer.play("Level")
		$AudioAnimation/AnimationPlayer.seek(animation_start_time)
		$AudioAnimation/AudioStreamPlayer.play(animation_start_time)
		Engine.set_time_scale(time_multiplier)
		$AudioAnimation/AudioStreamPlayer.pitch_scale = time_multiplier
		$"UI/UI_Above_Player/main menu".visible = false
		Globals.started = true
		$UI/UI_Below_Player/HSlider.visible = false
	if Input.is_action_just_pressed("pause") and not Globals.is_game_over and Globals.pausable:
		if Globals.is_paused == false:
			audio_time = $AudioAnimation/AnimationPlayer.get_current_animation_position()
			$AudioAnimation/AudioStreamPlayer.stop()
			Globals.is_paused = true
			$"UI/UI_Below_Player/pause menu".visible = true
			$UI/UI_Below_Player/HSlider.visible = true
			get_tree().paused = true
		else:
			Globals.is_paused = false
			$"UI/UI_Below_Player/pause menu".visible = false
			$UI/UI_Below_Player/HSlider.visible = false
			get_tree().paused = false
			$AudioAnimation/AudioStreamPlayer.play(audio_time)
	if Globals.is_game_over and not game_over_screen_appeared:
		game_over_screen_appeared = true 
		Globals.is_paused = true
		$"UI/UI_Below_Player/Game Over Screen".visible = true
		get_tree().paused = true
func quit():
	print("Hits took:")
	print(Globals.damage_counter)
	get_tree().quit()
func resync_audio(val:float):
	$AudioAnimation/AudioStreamPlayer.play(val)
func clear_bullets():
	for bullet in get_tree().get_nodes_in_group("Bullet"):
		if "is_delay" in bullet:
			if bullet.is_delay == true:
				continue
		bullet.queue_free()

func _on_retry_button_pressed() -> void:
	Globals.insta_start = true
	Globals.is_paused = false
	Globals.is_game_over = false
	game_over_screen_appeared = false
	$"UI/UI_Below_Player/Game Over Screen".visible = false
	get_tree().reload_current_scene()
	

func _on_main_menu_button_pressed() -> void:
	Globals.insta_menu = true
	Globals.pausable =  false
	Globals.started = false
	Globals.is_paused = false
	get_tree().paused = false
	Globals.is_game_over = false
	$"UI/UI_Below_Player/Game Over Screen".visible = false
	get_tree().reload_current_scene()
func set_pausable():
	Globals.pausable = false
	$"UI/UI_Below_Player/ending screen/RichTextLabel3".text = str("YOU GOT HIT " , Globals.damage_counter , " TIMES")


func _on_check_button_toggled(toggled_on: bool) -> void:
	Globals.is_infinite = toggled_on


func _on_button_pressed() -> void:
	get_tree().quit()


func _on_h_slider_value_changed(value: float) -> void:
	Globals.music_value = $HSlider.value

func _on_health_change():
	if not Globals.is_infinite:
		pass

func change_sky_colors_1(color):
	$Viewports/SubViewportContainer/SubViewport/WorldEnvironment.environment.sky.sky_material.set_shader_parameter("sky_top_color", color)

func change_sky_colors_2(color):
	$Viewports/SubViewportContainer/SubViewport/WorldEnvironment.environment.sky.sky_material.set_shader_parameter("sky_horizon_color", color)
	$Viewports/SubViewportContainer/SubViewport/WorldEnvironment.environment.sky.sky_material.set_shader_parameter("ground_bottom_color", color)
	$Viewports/SubViewportContainer/SubViewport/WorldEnvironment.environment.sky.sky_material.set_shader_parameter("ground_horizon_color", color)
	$Viewports/SubViewportContainer/SubViewport/WorldEnvironment.environment.fog_light_color = color

func change_exposure(expo):
	$Viewports/SubViewportContainer/SubViewport/WorldEnvironment.environment.sky.sky_material.set_shader_parameter("exposure", expo)
	$Viewports/SubViewportContainer/SubViewport/WorldEnvironment.environment.sky.sky_material.set_shader_parameter("sky_energy", 1/expo)
	$Viewports/SubViewportContainer/SubViewport/WorldEnvironment.environment.sky.sky_material.set_shader_parameter("ground_energy", 1/expo)

func change_cloud_alpha(val):
	$Viewports/SubViewportContainer/SubViewport/WorldEnvironment.environment.sky.sky_material.set_shader_parameter("cloud_alpha", val)

func change_overlay_alpha(val):
	$StormOverlay.modulate.a = val

func change_speed(val):
	$GroundSpawner.speed = val

func change_dust_alpha(val):
	$Viewports/background_dust.change_alpha(val)

func change_level_state_2():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_method(change_speed, 80, 320, transition_time)
	tween.tween_method(change_sky_colors_1, normal_sky_color_1, sky_storm_color_1, transition_time)
	tween.tween_method(change_sky_colors_2, normal_sky_color_2, sky_storm_color_2, transition_time)
	tween.tween_method(change_exposure, 1.0, exposure, transition_time)
	tween.tween_method(change_overlay_alpha, 0.0, 1.0, transition_time)
	tween.tween_method(change_cloud_alpha, 1.0, 0.0, transition_time)
	tween.tween_method(change_dust_alpha, 0.0, 0.8, transition_time)
	$UI/foreground_dust.emitting = true
	#change_sky_colors_1(sky_storm_color_1)
	#change_sky_colors_2(sky_storm_color_2)
	#change_exposure(exposure)
	#change_overlay_alpha(1)
	#change_cloud_alpha(0)


func change_level_state_3():
	$GroundSpawner.speed = 240
