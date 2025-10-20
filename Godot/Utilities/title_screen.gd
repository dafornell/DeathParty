extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GuiSystem.in_title_screen = true


func _on_settings_button_pressed() -> void:
	Events.title_screen_settings_button_pressed.emit()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_start_game_button_pressed() -> void:
	Events.title_screen_start_game_button_pressed.emit()
