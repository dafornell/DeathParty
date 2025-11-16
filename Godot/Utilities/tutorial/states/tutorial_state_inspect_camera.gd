extends TutorialState

@export var camera_item: InventoryItemResource

func enter_state() -> void:
	super()
	Events.ready_to_take_photo_of_corkboard.connect(transition, CONNECT_ONE_SHOT)
	# if camera_item was already viewed, transition immediately to 
	# prevent softlock
	if SaveSystem.get_inventory_item(camera_item.name).viewed:
		Events.ready_to_take_photo_of_corkboard.emit()
