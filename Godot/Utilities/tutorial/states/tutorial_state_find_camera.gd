extends TutorialState

@export var camera_item: InventoryItemResource

var _emitted_interactions_enabled := false

func enter_state() -> void:
	super()
	# the state can be reentered, so make sure
	# to only emit the signal once (though
	# emitting it twice shouldn't be a problem,
	# since connections should use CONNECT_ONE_SHOT anyway)
	if not _emitted_interactions_enabled:
		Events.interactables_enabled.emit()
		_emitted_interactions_enabled = true
	Events.interaction_area_entered.connect(_on_interaction_area_entered)

func exit_state() -> void:
	Events.interaction_area_entered.disconnect(_on_interaction_area_entered)
	super()

func _on_interaction_area_entered(interactable: Interactable) -> void:
	if interactable.inventory_item != camera_item:
		return
	transition()
