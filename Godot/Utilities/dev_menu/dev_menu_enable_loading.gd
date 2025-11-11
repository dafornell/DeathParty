extends BaseButton

func _ready() -> void:
	DevSettings.ensure_loaded()
	button_pressed = DevSettings.config.get_value(
		SaveSystem.dev_settings_section,
		SaveSystem.dev_settings_loading_enabled_key,
		true
	)
	toggled.connect(_on_toggled)

func _on_toggled(value: bool) -> void:
	DevSettings.config.set_value(
		SaveSystem.dev_settings_section,
		SaveSystem.dev_settings_loading_enabled_key,
		value
	)
	SaveSystem.loading_enabled = value
	DevSettings.save_to_filesystem()
