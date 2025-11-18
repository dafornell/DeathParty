extends Node


func _ready() -> void:
	Events.dialogue_line_displayed.connect(_on_dialogue_line_displayed)


func _on_dialogue_line_displayed(line: InkLineInfo) -> void:
	if "id" in line.metadata:
		_play_voice_line(line.metadata["id"])


func _play_voice_line(id: String) -> void:
	var event_instance = FmodServer.create_event_instance("event:/500_DX/VoiceLinePlayer")
	event_instance.set_programmer_callback(id)
	event_instance.start()
