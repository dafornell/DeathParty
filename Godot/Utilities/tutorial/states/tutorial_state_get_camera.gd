extends TutorialState

@export var find_camera_state: TutorialState
@export var camera_resource: InventoryItemResource

func enter_state() -> void:
	super()
	Events.interacted.connect(_on_interacted)
	Events.interaction_area_exited.connect(_on_interaction_area_exited)

func exit_state() -> void:
	Events.interacted.disconnect(_on_interacted)
	Events.interaction_area_exited.disconnect(_on_interaction_area_exited)
	super()

# go to find camera state if we exited range of camera
func _on_interaction_area_exited(interactable: Interactable) -> void:
	if interactable.inventory_item != camera_resource:
		return
	transition(find_camera_state)

func _on_interacted(interactable: Interactable) -> void:
	if interactable.inventory_item != camera_resource:
		return
	transition()
