
extends Node3D

@export var tail: TextureRect
@export var board: TextureRect
@export var text: Label

func _ready() -> void:
	set_text("example")
	change_board_size()

func set_text(bark: String) -> void:
	text.text = bark

func change_board_size() -> void:
	board.custom_minimum_size = text.size
