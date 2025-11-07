class_name SaveIcon extends Control

@export var animation_player: AnimationPlayer

func _ready() -> void:
	modulate.a = 0

func show_icon() -> void:
	animation_player.play(&"show")
