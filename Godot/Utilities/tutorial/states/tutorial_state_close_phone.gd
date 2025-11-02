extends TutorialState

func enter_state() -> void:
	super()
	Events.phone_closed.connect(transition, CONNECT_ONE_SHOT)
