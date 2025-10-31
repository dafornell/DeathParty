extends TutorialState

@export var rowan_invite_dialogue: JSON

var _in_phone := false
var _sent_message := false

func _ready() -> void:
	Events.phone_opened.connect(_phone_opened)
	Events.phone_closed.connect(_phone_closed)

func _phone_opened() -> void:
	_in_phone = true
	if active:
		transition()

func _phone_closed() -> void:
	_in_phone = false

func enter_state() -> void:
	super()
	if not _sent_message:
		DialogueSystem.to_phone("Rowan", rowan_invite_dialogue)
		_sent_message = true
		
	if _in_phone:
		transition()
