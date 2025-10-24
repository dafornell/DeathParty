extends NavigationAgent3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not OS.has_feature("editor"):
		debug_enabled = false
