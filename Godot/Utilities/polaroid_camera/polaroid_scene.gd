class_name PolaroidScene extends Control

@export var unfiltered_texture_rect: TextureRect
@export var red_texture_rect: TextureRect
@export var green_texture_rect: TextureRect
@export var blue_texture_rect: TextureRect

@export var unfiltered_picture_points: Array[PolaroidPicturePoint]
@export var red_picture_points: Array[PolaroidPicturePoint]
@export var green_picture_points: Array[PolaroidPicturePoint]
@export var blue_picture_points: Array[PolaroidPicturePoint]

var has_uncollected_picture_points: bool:
	get:
		var is_picture_point_not_in_inventory := func(point: PolaroidPicturePoint) -> bool:
			return not point.already_in_inventory
		return (
			unfiltered_picture_points.any(is_picture_point_not_in_inventory)
			or red_picture_points.any(is_picture_point_not_in_inventory)
			or green_picture_points.any(is_picture_point_not_in_inventory)
			or blue_picture_points.any(is_picture_point_not_in_inventory)
		)

const _default_filter_color = "white"

var _cur_texture_rect: TextureRect:
	get:
		return _color_texture_rect_dict[filter_color]

# note: this can *fail*, in that it will not set to the right value
# if that value has no corresponding texture
var filter_color: String = _default_filter_color:
	set(v):
		if v == filter_color: return
		if not is_node_ready():
			filter_color = v
			return
		
		if _cur_texture_rect != null:
			_cur_texture_rect.visible = false
		
		filter_color = v
		
		if _cur_texture_rect == null:
			filter_color = _default_filter_color
		_color_texture_rect_dict[filter_color].visible = true

var picture_points: Array[PolaroidPicturePoint]:
	get:
		match filter_color:
			"white": return unfiltered_picture_points
			"red": return red_picture_points
			"green": return green_picture_points
			"blue": return blue_picture_points
		assert(false, "Unreachable")
		return []

@onready var _color_texture_rect_dict: Dictionary[String, TextureRect] = {
	"white": unfiltered_texture_rect,
	"red": red_texture_rect,
	"green": green_texture_rect,
	"blue": blue_texture_rect,
}

func _ready() -> void:
	for texture_rect: TextureRect in _color_texture_rect_dict.values():
		if texture_rect == null:
			continue
		texture_rect.visible = false
	_color_texture_rect_dict[filter_color].visible = true
