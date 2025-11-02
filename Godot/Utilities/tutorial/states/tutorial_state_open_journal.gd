extends TutorialState

func enter_state() -> void:
	super()
	Events.journal_opened.connect(transition, CONNECT_ONE_SHOT)
