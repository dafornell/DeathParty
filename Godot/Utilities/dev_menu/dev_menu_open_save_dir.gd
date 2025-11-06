@tool
extends BaseButton

@export_tool_button("Open dir") var action := _on_pressed

func _ready() -> void:
	pressed.connect(_on_pressed)
	
func _on_pressed() -> void:
	OS.shell_show_in_file_manager(ProjectSettings.globalize_path("user://"))
