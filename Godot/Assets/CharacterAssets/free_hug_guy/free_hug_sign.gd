extends Node3D


# automatically show and hide the sign based on the current animation
func _on_animation_player_current_animation_changed(animation_name: String) -> void:
	if animation_name == "hold sign":
		show()
	else:
		hide()
