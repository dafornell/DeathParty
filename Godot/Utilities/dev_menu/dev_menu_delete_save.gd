extends BaseButton

func _ready() -> void:
	pressed.connect(_on_pressed)
	
func _on_pressed() -> void:
	SaveSystem.active_save_file.delete_from_filesystem()
