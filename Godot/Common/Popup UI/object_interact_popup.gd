@tool
extends Node3D

@export var x_offset: float = -1
@export var y_offset: float = 0.5

@onready var parent: Interactable = get_parent()

@export var prop_name: String = "prop name":
	set(name):
		prop_name = name
		%NameLabel.text = prop_name

@export var action: String = "examine":
	set(name):
		action = name
		%ActionLabel.text = action


func _physics_process(_delta: float) -> void:
	if parent != null and parent is Node3D:
		global_position = parent.global_position + Vector3(x_offset, y_offset, 0)
