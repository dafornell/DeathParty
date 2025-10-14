extends Interactable
#first barrel 
@export var take: Node3D
@export var barrel_one: Node3D
@export var barrel_two: Node3D
@export var barrel_three: Node3D
var tracker=0
func on_interact() -> void:
	if !enabled: return
	super()
	if tracker==0:
		barrel_one.visible=true
		#Globals.polaroid_camera_ui.start(png here)
		barrel_one.visible=false
		tracker+=1
	if tracker==1:
		barrel_two.visible=true
		#Globals.polaroid_camera_ui.start(png here)
		barrel_two.visible=false
		tracker+=1
	if tracker==2:
		barrel_three.visible=true
		#Globals.polaroid_camera_ui.start(png here)
		barrel_three.visible=false
		
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
