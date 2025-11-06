extends TutorialState

@export var find_camera_state: TutorialState
@export var camera_resource: InventoryItemResource

var _has_camera := false

func _ready() -> void:
	super()
	SaveSystem.inventory_changed.connect(_on_inventory_changed)
	# check if we already have the camera
	_on_inventory_changed("", null)

func _on_inventory_changed(_addremove: String, _item: InventoryItemResource) -> void:
	if SaveSystem.get_inventory_item(camera_resource.name).amount_owned == 0:
		return
	
	_has_camera = true
	SaveSystem.inventory_changed.disconnect(_on_inventory_changed)

	if active:
		transition()

func enter_state() -> void:
	super()
	Events.interaction_area_exited.connect(_on_interaction_area_exited)
	if _has_camera:
		transition()
		return

func exit_state() -> void:
	Events.interaction_area_exited.disconnect(_on_interaction_area_exited)
	super()

# go to find camera state if we exited range of camera
func _on_interaction_area_exited(interactable: Interactable) -> void:
	if interactable.inventory_item != camera_resource:
		return
	transition(find_camera_state)
