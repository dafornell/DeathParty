extends ScrollContainer


func _enter_tree() -> void:
	Events.dialogue_box_text_changed.connect(_on_text_changed)


func _on_text_changed() -> void:
	# we wait a frame first to make sure the text is rendered in the container
	# before we try to scroll it
	await get_tree().process_frame

	# NOTE: tbh im not sure exactly how to set it to as low as possible so i'll
#		just add a rlly big number lol
#				- jack
	scroll_vertical += 999
