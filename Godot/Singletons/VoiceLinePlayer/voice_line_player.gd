extends Node

func _ready() -> void:
	Events.dialogue_line_displayed.connect(_on_dialogue_line_displayed)

func _on_dialogue_line_displayed(line: InkLineInfo) -> void:
	if "id" in line.metadata:
		_play_voice_line(line.metadata["id"])

#TODO: Play the sound using FMOD
func _play_voice_line(id: String) -> void:
	pass
