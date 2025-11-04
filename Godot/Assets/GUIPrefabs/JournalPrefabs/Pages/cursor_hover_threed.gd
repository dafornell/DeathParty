class_name ThreeDCursorHover extends ThreeDGUI

@export var animation_player: AnimationPlayer

@export var default_animation_name: StringName = &""
@export var hovered_animation_name: StringName = &""

func _ready() -> void:
	if animation_player != null and not default_animation_name.is_empty():
		animation_player.play(default_animation_name)

##INHERITED
func enter_hover() -> void:
	super()
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	if animation_player != null and not hovered_animation_name.is_empty():
		animation_player.play(hovered_animation_name)
	
func exit_hover() -> void:
	super()
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	if animation_player != null and not default_animation_name.is_empty():
		animation_player.play(default_animation_name)
