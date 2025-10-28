@tool
extends Node3D


@export var prop_name: String = "prop name":
	set(name):
		prop_name = name
		%NameLabel.text = prop_name

@export var action: String = "examine":
	set(name):
		action = name
		%ActionLabel.text = action
