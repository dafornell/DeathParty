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


func give_all_inventory_items_with_unique_models() -> void:
	var added_models: Dictionary[Resource, bool] = {}
	var polaroids: Array[String] = []
	for item_name: String in SaveSystem.active_save_file.inventory_items.keys():
		if omit_set.has(item_name):
			continue
		var item_resource := SaveSystem.item_exists(item_name)
		if item_resource == null or item_resource.model == null:
			print("Item resource or model is null for item: ", item_name)
			continue
		if added_models.has(item_resource.model):
			print("Duplicate model found for item: ", item_name)
			continue
		added_models[item_resource.model] = true
		if item_name.ends_with("Polaroid"):
			polaroids.append(item_name)
			continue
		print("Adding item: ", item_name)
		SaveSystem.add_item(item_name)
	
	# add polaroids last
	for polaroid_name: String in polaroids:
		SaveSystem.add_item(polaroid_name)
