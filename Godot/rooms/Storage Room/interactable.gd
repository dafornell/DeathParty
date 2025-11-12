extends Interactable

func on_interact() -> void:
	if !enabled: return
	super()
	

	Globals.polaroid_camera_ui.start("res://Assets/PNGAssets/lamp_mirror.png","null","null")
	Globals.polaroid_camera_ui.visible = true
		
