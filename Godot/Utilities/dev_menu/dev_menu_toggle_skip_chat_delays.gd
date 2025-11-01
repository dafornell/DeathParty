extends Button

var init_text: String

func _ready() -> void:
	init_text = text
	pressed.connect(_on_pressed)
	_update_text()
	
func _on_pressed() -> void:
	Globals.skip_chat_delays = not Globals.skip_chat_delays
	_update_text()

func _update_text() -> void:
	text = "%s (current: %s)" % [
		init_text,
		str(Globals.skip_chat_delays)
	]
