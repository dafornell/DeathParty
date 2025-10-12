extends Interactable

@export var take: Node3D
@export var title:CanvasLayer

func _on_interaction_detector_player_interacted() -> void:
	#the title blocks the mouse click on the polaroid layer's buttons so have to make it invisible 
	title.visible=false
	Globals.polaroid_camera_ui.visible=true
	if Globals.polaroid_camera_ui.visible==true:
		Globals.player.movement_disabled = true
	print("camera scene should be on")


func _on_tutorial_ui_toggle_corkboard_interactable(value: bool) -> void:
	if value == true:
		interaction_detector.monitoring = true
	else:
		interaction_detector.monitoring = false
