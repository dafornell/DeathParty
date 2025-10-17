extends Interactable
#first barrel 
@export var take: Node3D
@export var barrel_popup: Node3D
var tracker=0
func on_interact() -> void:
	if !enabled: return
	super()
	
	if tracker==0:
		barrel_popup.visible=true
#		pass in the image and also the filtered image and the lens color  to polaroid layer script 
		Globals.polaroid_camera_ui.start("res://Assets/PNGAssets/barrels.png")
		
		tracker+=1
	if tracker==1:
		#Globals.polaroid_camera_ui.start(png here)
		tracker+=1
	if tracker==2:
		#Globals.polaroid_camera_ui.start(png here)
		barrel_popup.visible=false
		
	# TODO: create a global in_polaroid_camera variable, maybe with a setter
	#		function to handle enabling/disabling movement while player is
	#		using camera globally instead of doing it here
	#if Globals.polaroid_camera_ui.visible == true:
		#Globals.player.movement_disabled = true
	print("camera scene should be on")
func _on_tutorial_ui_toggle_corkboard_interactable(value: bool) -> void:
	if value == true:
		enabled = true
	else:
		enabled = false
