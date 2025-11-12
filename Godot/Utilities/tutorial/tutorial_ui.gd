class_name TutorialUI extends Node

signal toggle_corkboard_interactable(value: bool)
@export var start_state: TutorialState
@export var exterior_scene_loader: SceneLoader

const SAVE_KEY: String = "tutorial_completed"

func _ready() -> void:
	if SaveSystem.data.get(SAVE_KEY, false):
		finish_tutorial()
		return
	start_state.enter_state()

func finish_tutorial() -> void:
	SaveSystem.data.set(SAVE_KEY, true)
	exterior_scene_loader.enabled = true
	queue_free()
