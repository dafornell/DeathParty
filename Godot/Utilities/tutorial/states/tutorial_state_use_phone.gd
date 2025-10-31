extends TutorialState

@export var open_phone_state: TutorialState

func enter_state() -> void:
	super()
	Events.contact_pressed.connect(transition)
	Events.phone_closed.connect(_on_phone_closed)

func exit_state() -> void:
	Events.contact_pressed.disconnect(transition)
	Events.phone_closed.disconnect(_on_phone_closed)
	super()

func _on_phone_closed() -> void:
	transition(open_phone_state)
