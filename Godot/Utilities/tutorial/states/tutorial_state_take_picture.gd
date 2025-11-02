extends TutorialState
	
func _process(_delta: float) -> void:
	if Globals.polaroid_camera_ui.visible:
		transition()
