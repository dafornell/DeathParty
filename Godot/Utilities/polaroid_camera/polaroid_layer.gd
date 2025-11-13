class_name PolaroidLayer extends CanvasLayer

@export_group("Parameters")
@export var _move_speed: float = 200
@export var _close_camera_delay: float = 0.3

@export_group("Flash")
@export var _flash_animation_player: AnimationPlayer
@export var _flash_delay_time: float = 0.3
@export var _flash_animation_name: StringName = &"flash"

@export_group("References")
@export var _viewfinder_center: Control
@export var _take_photo_button: Button
@export var _scene_container: Control
@export var _filter_control: FilterControl

@export_group("Ready indicator")
@export var _ready_indicator: PolaroidReadyIndicator
@export var _ready_distance_threshold := 40.0
@export var _indicator_threshold := 500.0
@export var _indicator_intensity_curve: Curve

@export_group("Audio events")
@export var _open_camera_sound: FmodEventEmitter2D
@export var _take_photo_sound: FmodEventEmitter2D

var _polaroid_scene: PolaroidScene = null

var _closest_picture_point: PolaroidPicturePoint = null
var _closest_picture_point_distance: float = 0
var _can_take_picture: bool:
	get:
		return (
			visible
			and not _took_photo
			and _closest_picture_point != null
			and _closest_picture_point_distance < _ready_distance_threshold
		)

var _took_photo := false

# utility to convert get_viewport().size to Vector2 safely
var _viewport_size: Vector2:
	get:
		# get_viewport() either returns SubViewportContainer or Window
		# both of which have a Vector2 size
		# so this is safe by default
		@warning_ignore("unsafe_property_access")
		return get_viewport().size

func set_scene(scene: PolaroidScene) -> bool:
	if _polaroid_scene != null:
		_polaroid_scene.queue_free()
		_polaroid_scene = null
	assert(scene != null)
	# if no more picture points, just exit to prevent softlock
	if not scene.has_uncollected_picture_points:
		return false
	_scene_container.add_child(scene)
	_polaroid_scene = scene
	return true

func open_with_scene(scene: PolaroidScene) -> bool:
	if set_scene(scene):
		visible = true
		return true
	return false

func set_scene_from_packed(packed_scene: PackedScene) -> bool:
	var instance: PolaroidScene = packed_scene.instantiate()
	assert(instance != null, "packed_scene did not instantiate to a PolaroidScene")
	return set_scene(instance)

func open_with_scene_from_packed(packed_scene: PackedScene) -> bool:
	if set_scene_from_packed(packed_scene):
		visible = true
		return true
	return false

func _on_visibility_changed() -> void:
	if visible and _polaroid_scene != null:
		_on_camera_opened()
	elif not visible and _polaroid_scene != null:
		_on_camera_closed()

func _on_camera_opened() -> void:
	_took_photo = false
	_open_camera_sound.play()
	Globals.player.movement_disabled = true

func _on_camera_closed() -> void:
	Globals.player.movement_disabled = false

func _enter_tree() -> void:
	Globals.polaroid_camera_ui = self

func _ready() -> void:
	_take_photo_button.pressed.connect(_try_take_photo)
	visibility_changed.connect(_on_visibility_changed)
	_flash_animation_player.assigned_animation = _flash_animation_name
	_filter_control.filter_changed.connect(_on_filter_changed)

# function for movement of camera
func _process(delta: float) -> void:
	if not visible: return
	
	if Input.is_action_just_pressed("take_picture"):
		_try_take_photo()

	_move_picture(delta)
	_clamp_picture_position()
	_find_closest_picture_point()
	_process_indicators()

func _try_take_photo() -> void:
	if not _can_take_picture:
		return
	
	_took_photo = true
	
	_take_photo_sound.play()
	await get_tree().create_timer(_flash_delay_time).timeout
	
	_flash_animation_player.seek(0)
	_flash_animation_player.play()
	await _flash_animation_player.animation_finished
	
	await get_tree().create_timer(_close_camera_delay).timeout
	
	var inventory_item := _closest_picture_point.polaroid_item
	assert(inventory_item != null, "Picture point has no polaroid_item")
	
	SaveSystem.add_item(inventory_item.name, true)
	
	visible = false
	
		
func _move_picture(delta: float) -> void:
	if _took_photo:
		return
	
	var move_dir := Input.get_vector(
		"move_left", "move_right",
		"move_up", "move_down"
	)
	# negative b/c moving background instead of foreground
	_scene_container.position += -move_dir * delta * _move_speed

func _clamp_picture_position() -> void:
	if _polaroid_scene == null:
		return
	var viewport_size := _viewport_size
	var lower_bound := viewport_size - _polaroid_scene.size
	_scene_container.position = _scene_container.position.clamp(
		lower_bound,
		Vector2.ZERO
	)

func _find_closest_picture_point() -> void:
	if _polaroid_scene == null:
		return
	var closest: PolaroidPicturePoint = null
	var closest_distance_squared := 0.0
	var viewfinder_center_position := _viewfinder_center.global_position
	
	# find the closest picture point
	for picture_point: PolaroidPicturePoint in _polaroid_scene.picture_points:
		var distance_squared := viewfinder_center_position.distance_squared_to(
			picture_point.global_position
		)
		if closest == null:
			closest = picture_point
			closest_distance_squared = distance_squared
			continue
		elif distance_squared < closest_distance_squared:
			closest = picture_point
			closest_distance_squared = distance_squared
	
	_closest_picture_point = closest
	_closest_picture_point_distance = sqrt(closest_distance_squared)

func _process_indicators() -> void:
	if _polaroid_scene == null:
		return
	
	if _took_photo:
		_ready_indicator.aim_indicator_intensity = 0
		_ready_indicator.ready_to_take = false
		return
	
	var distance_percent := clampf(
		(_closest_picture_point_distance - _ready_distance_threshold)
		/ (_indicator_threshold - _ready_distance_threshold),
		0.0,
		1.0
	)
	var intensity_t := 1.0 - distance_percent
	var intensity := _indicator_intensity_curve.sample(intensity_t)
	_ready_indicator.aim_indicator_intensity = intensity
	_ready_indicator.ready_to_take = _can_take_picture

func _on_filter_changed(new_color: String) -> void:
	if _polaroid_scene == null:
		return
	
	_polaroid_scene.filter_color = new_color
