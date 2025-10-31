extends TutorialState

func enter_state() -> void:
	super()
	Events.ready_to_take_photo_of_corkboard.connect(transition)
