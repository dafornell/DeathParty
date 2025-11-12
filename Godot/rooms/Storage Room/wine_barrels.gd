extends Interactable
#first barrel 

#var tracker=0
func on_interact() -> void:
	if !enabled: return
	super()
	
	#if tracker==0:
	print("wine barrel interacted")
#		pass in the image and also the filtered image and the lens color  to polaroid layer script 
#	call function that sets the area 2d's and their position 
	Globals.polaroid_camera_ui.start("res://Assets/PNGAssets/barrels_normal.png","R","res://Assets/PNGAssets/barrel_red.png")
#	call the target function with set positions and sizes here 
	Globals.polaroid_camera_ui.visible = true
		#tracker+=1
	#if tracker==1:
		##Globals.polaroid_camera_ui.start(png here)
		#tracker+=1
	#if tracker==2:
		##Globals.polaroid_camera_ui.start(png here)
		#barrel_popup.visible=false
		#
	# TODO: create a global in_polaroid_camera variable, maybe with a setter
	#		function to handle enabling/disabling movement while player is
	#		using camera globally instead of doing it here
	#if Globals.polaroid_camera_ui.visible == true:
		#Globals.player.movement_disabled = true
	print("camera scene should be on")
