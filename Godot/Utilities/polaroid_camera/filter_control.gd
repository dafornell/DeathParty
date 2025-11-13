class_name FilterControl extends Node2D

@export var rotate_tween_duration: float = 0.3

@export var left_button: Button
@export var right_button: Button
@export var filter_base_button :Button
@export var lens: TextureRect
@export var ViewFinder: TextureRect
@export var filter_letter: TextureRect 

@export var letter_n_texture: Texture
@export var letter_r_texture: Texture
@export var letter_g_texture: Texture
@export var letter_b_texture: Texture

@export var red_filter_texture: Texture
@export var green_filter_texture: Texture
@export var blue_filter_texture: Texture

@export var filter_base: Sprite2D

@onready var _color_letter_map: Dictionary[String, Texture] = {
	"white": letter_n_texture,
	"red": letter_r_texture,
	"green": letter_g_texture,
	"blue": letter_b_texture,
}

@onready var _color_filter_map: Dictionary[String, Texture] = {
	"white": null,
	"red": red_filter_texture,
	"green": green_filter_texture,
	"blue": blue_filter_texture,
}

signal filter_changed(new_color: String)

func _on_left_button_pressed() -> void:
	_rotate(-90)
	
func _on_right_button_pressed() -> void:
	_rotate(90)

func _on_filter_base_button_pressed() -> void:
	_rotate(-90)

func _rotate(delta_degrees: float) -> void:
	right_button.disabled = true
	left_button.disabled = true
	filter_base_button.disabled = true
	
	var current_rotation := filter_base.rotation_degrees
	current_rotation += delta_degrees
	
	var tween := create_tween()
	tween.tween_property(
		filter_base,
		"rotation",
		deg_to_rad(current_rotation),
		rotate_tween_duration
	)
	
	await tween.finished
	
	right_button.disabled = false
	left_button.disabled = false
	filter_base_button.disabled = false

#function for detecting what color is at the top of the wheel (the selected filter) 
func _on_selector_area_shape_entered(
	_area_rid: RID,
	area: Area2D,
	_area_shape_index: int,
	_local_shape_index: int
) -> void:
	#the top of the wheel has an area 2D that detects what color is at the top position and passes that color to the "lens change" function to apply the corresponding filter
	if area.name not in ["white", "blue", "red", "green"]:
		push_error("Unknown area name in filter_control")
		return
	
	lens_change(area.name)

#function for displaying the filter color 
func lens_change(lens_color: String) -> void:
	print("LENS CHANGE " + lens_color)
	lens.visible = lens_color != "white"
	lens.texture = _color_filter_map[lens_color]
	filter_letter.texture = _color_letter_map[lens_color]
	filter_changed.emit(lens_color)
