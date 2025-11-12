extends TutorialState

@export var camera_item: InventoryItemResource

var _emitted_interactions_enabled := false

var _has_camera := false

func _ready() -> void:
	super()
	SaveSystem.inventory_changed.connect(_on_inventory_changed)
	# check if we already have the camera
	_on_inventory_changed("", null)

func _on_inventory_changed(_addremove: String, _item: InventoryItemResource) -> void:
	if SaveSystem.get_inventory_item(camera_item.name).amount_owned == 0:
		return
	
	_has_camera = true
	SaveSystem.inventory_changed.disconnect(_on_inventory_changed)

	if active:
		transition()

func enter_state() -> void:
	super()
	if not _emitted_interactions_enabled:
		Events.interactables_enabled.emit()
		_emitted_interactions_enabled = true
	Events.interaction_area_entered.connect(_on_interaction_area_entered)

	if _has_camera:
		transition()
		return

func exit_state() -> void:
	Events.interaction_area_entered.disconnect(_on_interaction_area_entered)
	super()

func _on_interaction_area_entered(interactable: Interactable) -> void:
	if interactable.inventory_item != camera_item:
		return
	transition()
