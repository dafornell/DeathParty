@tool
class_name Arrows extends Node

@export var left_arrow_visible: bool = true:
	set(v):
		left_arrow_visible = v
		left_arrow.visible = v

@export var right_arrow_visible: bool = true:
	set(v): 
		right_arrow_visible = v
		right_arrow.visible = v

@export_group("Node references")
@export var left_arrow: ThreeDGUI
@export var right_arrow: ThreeDGUI

func _ready() -> void:
	left_arrow.visible = left_arrow_visible
	right_arrow.visible = right_arrow_visible
