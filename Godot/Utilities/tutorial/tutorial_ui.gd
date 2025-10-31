class_name TutorialUI extends Node


@export var start_state: TutorialState
@export var exterior_scene_loader: SceneLoader

func _ready() -> void:
	start_state.enter_state()

func finish_tutorial() -> void:
	exterior_scene_loader.enabled = true
	queue_free()
