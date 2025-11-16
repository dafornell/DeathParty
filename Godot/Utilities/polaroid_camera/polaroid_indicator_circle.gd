@tool
class_name PolaroidIndicatorRing extends TextureRect

@export_range(0, 1) var pulse_position: float:
	set(v):
		v = clampf(v, 0.0, 1.0)
		pulse_position = v
		if is_node_ready():
			_update_pulse()

@export_group("Gradient settings")
@export var gradient: Gradient
@export var gradient_color := Color(1, 0xee/255.0, 0x51/255.0, 1)
@export_range(0, 1) var gradient_lower_bound: float = 0
@export_range(0, 1) var gradient_upper_bound: float = sqrt(2)/2
@export_range(0, 1) var gradient_ring_width: float = 0.25
@export_range(0, 1) var gradient_ring_center: float = 0.3

func _ready() -> void:
	_init_gradient()
	_update_pulse()

func _init_gradient() -> void:
	gradient.offsets = PackedFloat32Array([0.0,0.0,0.0])
	var transparent_gradient_color := gradient_color
	transparent_gradient_color.a = 0
	gradient.colors = PackedColorArray([
		transparent_gradient_color,
		gradient_color,
		transparent_gradient_color
	])

func _update_pulse() -> void:
	var upper_width := gradient_ring_width * (1 - gradient_ring_center)
	var center := pulse_position * (gradient_upper_bound - gradient_lower_bound + gradient_ring_width) + gradient_lower_bound - upper_width
	var lower := center - gradient_ring_width * gradient_ring_center
	var upper := lower + gradient_ring_width
	
	gradient.offsets[0] = clamp(lower, gradient_lower_bound, gradient_upper_bound)
	gradient.offsets[1] = clamp(center, gradient_lower_bound, gradient_upper_bound)
	gradient.offsets[2] = clamp(upper, gradient_lower_bound, gradient_upper_bound)
