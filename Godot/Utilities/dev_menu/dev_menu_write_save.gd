extends BaseButton

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	SaveSystem.save_to_disk()
