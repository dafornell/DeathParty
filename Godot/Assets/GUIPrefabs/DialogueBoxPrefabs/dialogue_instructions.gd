extends Label


func _enter_tree() -> void:
	Events.toggle_dialogue_instructions.connect(toggle)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween: Tween = create_tween()
	tween.set_loops()
	tween.tween_interval(1)
	tween.tween_property(self, "modulate:a", 0, 1.25)
	tween.tween_property(self, "modulate:a", 1, 0.75)


func toggle(value: bool) -> void:
	visible = value
