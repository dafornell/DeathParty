extends Interactable

func on_interact() -> void:
	if !enabled: return
	super()

	Globals.polaroid_camera_ui.start("res://Assets/PNGAssets/barrels_normal.png","R","res://Assets/PNGAssets/barrel_red.png")
	Globals.polaroid_camera_ui.visible = true
	
