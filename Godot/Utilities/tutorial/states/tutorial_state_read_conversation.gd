extends TutorialState

@export var open_phone_state: TutorialState
@export var open_message_state: TutorialState

var invited := false

func _ready() -> void:
	Events.party_invite_accepted.connect(_on_rowan_invite_finished, CONNECT_ONE_SHOT)

func _on_rowan_invite_finished() -> void:
	invited = true
	if active:
		transition()

func enter_state() -> void:
	super()
	Events.phone_closed.connect(_on_phone_closed)
	Events.message_app_back_pressed.connect(_on_back_pressed)
	if invited:
		transition()

func exit_state() -> void:
	Events.phone_closed.disconnect(_on_phone_closed)
	Events.message_app_back_pressed.disconnect(_on_back_pressed)
	super()

func _on_phone_closed() -> void:
	transition(open_phone_state)

func _on_back_pressed() -> void:
	transition(open_message_state)
