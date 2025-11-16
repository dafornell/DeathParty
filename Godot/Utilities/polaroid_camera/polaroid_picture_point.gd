class_name PolaroidPicturePoint extends Control

@export var polaroid_item: InventoryItemResource

var already_in_inventory: bool:
	get:
		return SaveSystem.item_exists(polaroid_item.name).amount_owned > 0

func _ready() -> void:
	if already_in_inventory:
		queue_free()
