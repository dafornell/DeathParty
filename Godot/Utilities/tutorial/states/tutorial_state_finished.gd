extends TutorialState

@export var tutorial_ui: TutorialUI

func enter_state() -> void:
	super()
	end()
	tutorial_ui.finish_tutorial()
