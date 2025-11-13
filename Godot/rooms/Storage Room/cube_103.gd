extends Interactable

func on_interact() -> void:
	if !enabled: return
	super()
	
	#if tracker==0:
	print("wine barrel interacted")
#		pass in the image and also the filtered image and the lens color  to polaroid layer script 
	Globals.polaroid_camera_ui.start("res://Assets/PNGAssets/lamp_mirror.png","R","null")
	Globals.polaroid_camera_ui.visible = true

	print("camera scene should be on")
