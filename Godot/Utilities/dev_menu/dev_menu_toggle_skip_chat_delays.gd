extends CheckButton

func _ready() -> void:
	Globals.skip_chat_delays = button_pressed
	pressed.connect(_on_pressed)
	
func _on_pressed() -> void:
	Globals.skip_chat_delays = button_pressed
