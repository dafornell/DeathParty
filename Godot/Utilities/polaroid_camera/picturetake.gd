extends Button
@export var question_mark : Area3D
@export var Polaroid_image : MeshInstance3D

#currently closes the scene think because it is taking in the E input when u open the scene 
#func _physics_process(delta: float) -> void:
	#if Input.is_action_just_pressed("take_picture"):
		#_on_pressed()
func _on_pressed():
	print("CLICKED BUTTON")
	await get_tree().create_timer(0.3).timeout
	#code for flash 
	print("picture taken")
	$flash.visible=true
	var tween=create_tween()
	tween.tween_property($flash, "modulate:a", 0, 1)
	await tween.finished
	#await get_tree().create_timer(1.2).timeout
	await get_tree().create_timer(0.3).timeout
	Globals.player.movement_disabled = false
	Globals.polaroid_camera_ui.visible=false
	if(Polaroid_image):
		Polaroid_image.turn_off()
