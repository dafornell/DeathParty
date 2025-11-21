extends NPC


func _enter_tree() -> void:
	Events.caleb_entrance_convo_finished.connect(_on_entrance_convo_finished)


func _on_entrance_convo_finished() -> void:
	fade_away_then_delete()
