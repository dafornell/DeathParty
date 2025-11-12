class_name SaveIcon extends Control

@export var animation_player: AnimationPlayer

func _ready() -> void:
	modulate.a = 0
	animation_player.assigned_animation = &"show"

func show_icon() -> void:
	animation_player.seek(0)
	animation_player.play()
