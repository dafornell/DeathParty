extends Control

@export var target: Control
@export var match_x: bool = false
@export var match_y: bool = false

func _ready() -> void:
	assert(target != null)
	target.minimum_size_changed.connect(_on_target_resized)

func _on_target_resized() -> void:
	var target_minimum_size := target.get_minimum_size()
	var new_minimum_size := custom_minimum_size
	if match_x:
		new_minimum_size.x = target_minimum_size.x
	if match_y:
		new_minimum_size.y = target_minimum_size.y
	custom_minimum_size = new_minimum_size
