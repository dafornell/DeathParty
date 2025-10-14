extends FmodEventEmitter2D


func _on_polaroid_camera_visibility_changed() -> void:
	var camera_ui: CanvasLayer = Globals.polaroid_camera_ui

	# i think there's something else that gets called while loading the game
	# which hides this canvas layer we're referencing, and if this function
	# gets called then and tries to reference it that early we get an error
	# so i just added this for safety
	#		- jack
	if camera_ui == null:
		return

	if camera_ui.visible:
		play()
