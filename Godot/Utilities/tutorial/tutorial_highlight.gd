class_name TutorialHighlight extends Control

@export var visible_alpha: float = 0.7

var target_node_3d: Node3D = null:
	set(v):
		if target_node_3d == v: return
		if v == null or target_node_3d == null:
			_tween_alpha(v != null)
		target_node_3d = v

const TWEEN_DURATION := 0.1

var _init_pos: Vector2
var _alpha_tween: Tween = null

func _ready() -> void:
	_init_pos = position
	visible = false
	modulate.a = 0

func _tween_alpha(target_visible: bool) -> void:
	if _alpha_tween: _alpha_tween.kill()
	_alpha_tween = get_tree().create_tween()
	var target_alpha := visible_alpha if target_visible else 0.0
	if target_visible:
		show()
	_alpha_tween.tween_property(self, "modulate:a", target_alpha, TWEEN_DURATION)
	if not target_visible:
		_alpha_tween.tween_callback(hide)

func _process(_delta: float) -> void:
	if not target_node_3d: return
	var obj_viewport := target_node_3d.get_viewport()
	var obj_viewport_size: Vector2i = obj_viewport.get("size")
	var screen_pos := obj_viewport.get_camera_3d().unproject_position(
		target_node_3d.global_position
	)
	var uv := screen_pos / Vector2(obj_viewport_size)
	
	var viewport_size := get_viewport_rect().size
	var pixels := uv * viewport_size
	position = _init_pos + pixels
