extends Room3D

@export var fade_title: Control
@export var title_screen: CanvasLayer
@export var closet: Node3D

@onready var music: FmodEventEmitter3D = %Music
@onready var look_straight: Vector3 = Vector3(path_follow_node.global_position.x, path_follow_node.global_position.y, -basis.z.z)

var _active_tween: Tween = null
var _active_timer: SceneTreeTimer = null
var _skipped: bool = false
var _finished: bool = false

const bedroom_camera_offset_LR := Vector3(.61, 0, 0)

func _enter_tree() -> void:
	Events.title_screen_start_game_button_pressed.connect(_on_play)

func _ready() -> void:
	super()
	GlobalCameraScript.move_camera_jump.emit()
	body_entered.connect(handle_player_entrance)
	Events.tutorial_skipped.connect(_on_tutorial_skipped)


func handle_player_entrance(body: Node3D) -> void:
	GlobalCameraScript.move_camera_jump.emit()
	remove_all_bounds(body)
	rotate_player(body)
	bind_camera_path(body)
	#var bedroom_camera_offset_LR: Vector3 = Vector3(.61, 0, 0)
	#bind_camera_LR(body, room_area_center-bedroom_camera_offset_LR, room_area_center+bedroom_camera_offset_LR)
	bind_camera_y(body, 1.2, 1.6)
	var bedroom_camera_depth_point: Vector3 = Vector3(0, 0, 34.4)
	bind_camera_depth(body, Vector3.ZERO, bedroom_camera_depth_point)

	#await get_tree().create_timer(1).timeout
	await GlobalCameraScript.finished_moving
	GlobalCameraScript.move_camera_smooth.emit()
	
	path_follow_node.look_at(look_straight) # Look straight ahead
	# ^ currently unneeded due to rotation mode None in path follow node

	#keep_camera_on_player(body)
	#bind_camera_y(body, 1.5, 1.5)


func _on_scene_loader_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		music.stop()

func _on_tutorial_skipped() -> void:
	if _finished:
		return
	
	_skipped = true
	_finished = true
	
	if _active_timer:
		_active_timer.time_left = 0.0
	if _active_tween:
		_active_tween.stop()
		_active_tween.finished.emit()
		_active_tween.kill()
	
	_setup_level()

func _on_play() -> void:
	if _skipped: return
	
	_active_timer = get_tree().create_timer(1)
	await _active_timer.timeout
	if _skipped: return

	closet.visible = true
	
	_active_tween = get_tree().create_tween()
	_active_tween.tween_property(path_follow_node, "progress_ratio", 1, 1.2)
	await _active_tween.finished
	if _skipped: return
	
	_setup_level()

func _setup_level() -> void:
	path_follow_node.progress_ratio = 1.2
	
	closet.visible = true
	
	bind_camera_LR(null, room_area_center-bedroom_camera_offset_LR, room_area_center+bedroom_camera_offset_LR)
	bind_camera_y(null, 1.2, 1.35)

	GlobalCameraScript.camera_on_player.emit(true)
	Events.intro_finished.emit()
	_finished = true
