# tool so that start_size_mult can be updated to actually 
# show the size
@tool
class_name TutorialHighlight extends Control

@export var visible_alpha: float = 0.7
@export var default_size_mult: float = 1.0:
	set(v):
		if default_size_mult == v: return
		default_size_mult = v
		_size_mult = default_size_mult
		_update_texture_size(true)

@export_group("Node references")
@export var highlight_oval: TextureRect

var _size_mult: float
var size_mult: float:
	get: return _size_mult
	set(v):
		if _size_mult == v: return
		_size_mult = v
		_update_texture_size(false)

@export_group("Target")

@export var target_node_3d: Node3D = null:
	set(v):
		if target_node_3d == v: return
		if v == null or target_node_3d == null:
			_tween_alpha(v != null)
		target_node_3d = v

## offset from the center of the 3D node to where we want the highlight to center
@export var target_node_offset_worldspace: Vector3 = Vector3.ZERO

const TWEEN_DURATION := 0.1

# Assume the highlight oval is initially in the top left (0,0 in UV)
# so that we can use the equation _init_pos + screen_size * UV to 
# get the position needed for the oval to be at an arbitrary point on screen
var _init_pos: Vector2
var _alpha_tween: Tween = null

var _size_tween: Tween = null

func _ready() -> void:
	_init_pos = position
	if not Engine.is_editor_hint():
		visible = false
		modulate.a = 0
		set_size_mult_instant(default_size_mult)

func set_size_mult_instant(v: float) -> void:
	_size_mult = v
	_update_texture_size(true)

func _update_texture_size(instant: bool) -> void:
	assert(highlight_oval != null)
	assert(highlight_oval.texture != null)
	if _size_tween:
		_size_tween.kill()
		_size_tween = null
	
	var texture_size := highlight_oval.texture.get_size()
	var target_size := texture_size * size_mult
	if instant:
		highlight_oval.custom_minimum_size.x = target_size.x
	else:
		_size_tween = get_tree().create_tween()
		_size_tween.tween_property(
			highlight_oval,
			"custom_minimum_size:x",
			target_size.x,
			TWEEN_DURATION
		)

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
		target_node_3d.global_position + target_node_offset_worldspace
	)
	var uv := screen_pos / Vector2(obj_viewport_size)
	
	var viewport_size := get_viewport_rect().size
	var pixels := uv * viewport_size
	position = _init_pos + pixels
