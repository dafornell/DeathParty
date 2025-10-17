extends Node

# some items are broken
@export var omit: Array[String] = ["polaroid"]

var omit_set: Dictionary[String, bool] = {}

func _ready() -> void:
	for item_name: String in omit:
		omit_set[item_name] = true

func _on_pressed() -> void:
	for item_name: String in SaveSystem.active_save_file.inventory_items.keys():
		if omit_set.has(item_name):
			continue
		SaveSystem.add_item(item_name)
