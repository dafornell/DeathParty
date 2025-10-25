extends Interactable
#first barrel 
@export var take: Node3D

#var tracker=0
func on_interact() -> void:
	if !enabled: return
	super()
	
	#if tracker==0:
	print("wine barrel interacted")
#		pass in the image and also the filtered image and the lens color  to polaroid layer script 
	Globals.polaroid_camera_ui.start("res://Assets/PNGAssets/barrels.png","R","res://Assets/PNGAssets/filter_barrels.png")
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
