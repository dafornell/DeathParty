extends Button


func _on_pressed() -> void:
	Events.title_screen_settings_button_pressed.emit()
