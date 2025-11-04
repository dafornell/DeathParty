class_name TutorialUI extends Node

signal toggle_corkboard_interactable(value: bool)
@export var start_state: TutorialState
@export var exterior_scene_loader: SceneLoader

func _ready() -> void:
	start_state.enter_state()

func finish_tutorial() -> void:
	exterior_scene_loader.enabled = true
	queue_free()
