extends Interactable

@onready var removal_sound: FmodEventEmitter3D = %RemovalSound


func _enter_tree() -> void:
	Events.basement_tape_conversation_finished.connect(_on_conversation_finished)
	# i think we need to wait a frame here for the save file to get loaded
	await get_tree().process_frame
	if SaveSystem.get_key("basement_tape_cleared") == true:
		queue_free()


func _on_conversation_finished() -> void:
	SaveSystem.set_key("basement_tape_cleared", true)
	SaveSystem.save_to_disk()
	fade_away_then_delete()
	removal_sound.play()
