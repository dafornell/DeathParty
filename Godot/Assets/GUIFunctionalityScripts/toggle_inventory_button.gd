extends ObjectViewerInteractable


func on_mouse_down() -> void:
	if GuiSystem.inventory_showing:
		Events.close_inventory.emit()
	else:
		Events.open_inventory.emit()
