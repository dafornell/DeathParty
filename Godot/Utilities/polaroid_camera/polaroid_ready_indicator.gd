@tool
class_name PolaroidReadyIndicator extends Node

@export_range(0.0, 1.0) var alpha: float = 1.0:
	set(v):
		alpha = clampf(v, 0.0, 1.0)
		if is_node_ready():
			_update_indicators()

@export var ready_to_take: bool = false:
	set(v):
		ready_to_take = v
		if is_node_ready():
			_update_indicators()

@export var tween_duration: float = 0.1

@export_group("References")
@export var input_indicator: Control
@export var aim_indicator: Control

var _input_indicator_tween: Tween = null

func _ready() -> void:
	_update_indicators()

func _update_indicators() -> void:
	assert(input_indicator != null)
	assert(aim_indicator != null)
	aim_indicator.modulate.a = alpha
	_tween_input_indicator_alpha(1.0 if ready_to_take else 0.0)
	
func _tween_input_indicator_alpha(value: float) -> void:
	if _input_indicator_tween:
		_input_indicator_tween.kill()
		_input_indicator_tween = null
	
	_input_indicator_tween = get_tree().create_tween()
	_input_indicator_tween.tween_property(
		input_indicator,
		"modulate:a",
		value,
		tween_duration
	)
