@tool
class_name PolaroidReadyIndicator extends Node

@export_range(0.0, 1.0) var aim_indicator_intensity: float = 1.0:
	set(v):
		aim_indicator_intensity = clampf(v, 0.0, 1.0)
		if is_node_ready():
			_update_indicators()

@export var ready_to_take: bool = false:
	set(v):
		ready_to_take = v
		if is_node_ready():
			_update_indicators()

@export var _tween_duration: float = 0.1

@export var _min_animation_speed := 0.5
@export var _max_animation_speed := 2.0

@export_group("References")
@export var _input_indicator: Control
@export var _aim_indicator: Control
@export var _aim_indicator_animation_players: Array[AnimationPlayer] = []

var _input_indicator_tween: Tween = null

func _ready() -> void:
	_update_indicators()

func _update_indicators() -> void:
	assert(_input_indicator != null)
	assert(_aim_indicator != null)
	_aim_indicator.modulate.a = aim_indicator_intensity
	var animation_speed := lerpf(_min_animation_speed, _max_animation_speed, aim_indicator_intensity)
	for animation_player: AnimationPlayer in _aim_indicator_animation_players:
		animation_player.speed_scale = animation_speed
	
	_tween_input_indicator_alpha(1.0 if ready_to_take else 0.0)
	
func _tween_input_indicator_alpha(value: float) -> void:
	if _input_indicator_tween:
		_input_indicator_tween.kill()
		_input_indicator_tween = null
	
	_input_indicator_tween = get_tree().create_tween()
	_input_indicator_tween.tween_property(
		_input_indicator,
		"modulate:a",
		value,
		_tween_duration
	)
