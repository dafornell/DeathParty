extends Node

var _is_initial_load := true

func _ready() -> void:
	ContentLoader.switched_scene.connect(_autosave)

func _autosave() -> void:
	if _is_initial_load:
		_is_initial_load = false
		return
	SaveSystem.save_to_disk()
