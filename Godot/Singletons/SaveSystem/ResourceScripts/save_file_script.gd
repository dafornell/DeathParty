class_name SaveFile extends Resource

const _SAVED_RESOURCES_TYPE_HINT := [TYPE_STRING, TYPE_STRING, PROPERTY_HINT_DIR]
@export_custom(PROPERTY_HINT_TYPE_STRING, "%d:;%d/%d:" % _SAVED_RESOURCES_TYPE_HINT)
var saved_resource_dirs: Dictionary[String, String]

@export var player_data: PlayerData
@export var tasks: Dictionary[String, TaskResource] = {}
@export var characters: Dictionary[String, CharacterResource] = {}
@export var talking_objects: Dictionary[String, TalkingObjectResource] = {}
@export var phone_chats: Dictionary[String, ChatResource] = {}
@export var inventory_items: Dictionary[String, InventoryItemResource] = {}
@export var journal_items: Dictionary[String, JournalItemResource] = {}

var base_path: String = "user://save/"
var file_path: String = "user://save.json"

class SavedResource:
	var category: String
	var name: String
	var resource: DefaultResource

func _load_directory_resources_into_dictionary(directory: String, output_dict: Dictionary) -> void:
	var dict_keys: Array[String] = []
	var dir: DirAccess = DirAccess.open(directory)
	if not dir:
		push_error("Could not open directory \"%s\" for loading into SaveSystem" % directory)
		return
	dir.list_dir_begin()
	var file_name: String = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			var resource: DefaultResource = load(directory.path_join(file_name))
			if resource == null:
				push_warning(
					"Resource \"%s\" is not of type DefaultResource" % file_name
				)
				continue
			dict_keys.push_back(resource.name)
			if not output_dict.has(resource.name):
				var cloned_resource: DefaultResource = resource.duplicate(true)
				cloned_resource.initialize()
				output_dict[resource.name] = cloned_resource
		
		file_name = dir.get_next()

func load_from_resources() -> void:
	for saved_resource_key in saved_resource_dirs:
		var saved_resource_dir: String = saved_resource_dirs[saved_resource_key]
		var save_file_dictionary: Dictionary = get(saved_resource_key)
		_load_directory_resources_into_dictionary(saved_resource_dir, save_file_dictionary)

func _add_saved_resources_to_dict(
	output_dict: Dictionary[String, Dictionary],
	category: String,
	resource_dict: Dictionary,
) -> void:
	var saved_resources: Dictionary[String, SavedResource] = {}
	for key: String in resource_dict.keys():
		var saved_resource: SavedResource = SavedResource.new()
		var resource: DefaultResource = resource_dict[key]
		if not resource:
			push_error("Resource \"%s\" is not a default resource, skipping..." % [resource_dict[key]])
			continue
		if key.is_empty():
			push_error("Resource \"%s\" has no name, skipping..." % [key])
			continue
		saved_resource.category = category
		saved_resource.name = key
		saved_resource.resource = resource_dict[key]
		saved_resources[key] = saved_resource
	output_dict[category] = saved_resources

# Dictionary[String, Dictionary[String, SavedResource]]
func get_saved_resources() -> Dictionary[String, Dictionary]:
	var all_saved_resources: Dictionary[String, Dictionary] = {}
	_add_saved_resources_to_dict(all_saved_resources, "tasks", tasks)
	_add_saved_resources_to_dict(all_saved_resources, "characters", characters)
	_add_saved_resources_to_dict(all_saved_resources, "talking_objects", talking_objects)
	_add_saved_resources_to_dict(all_saved_resources, "phone_chats", phone_chats)
	_add_saved_resources_to_dict(all_saved_resources, "inventory_items", inventory_items)
	_add_saved_resources_to_dict(all_saved_resources, "journal_items", journal_items)
	_add_saved_resources_to_dict(all_saved_resources, "player_data", {
		"player_data": player_data
	})
	
	return all_saved_resources

func serialize(dict: Dictionary) -> String:
	if OS.has_feature("editor"):
		return JSON.stringify(
			dict,
			"  ", # indent
		)
	else:
		return JSON.stringify(
			dict,
			"",
			false, # don't sort keys
		)

func deserialize(string: String) -> Dictionary:
	return JSON.parse_string(string)

func save_to_filesystem() -> void:	
	var output_dict := {}
	var saved_resources := get_saved_resources()
	for category: String in saved_resources:
		output_dict[category] = {}
		for saved_resource_name: String in saved_resources[category]:
			var saved_resource: SavedResource = saved_resources[category][saved_resource_name]
			var serialized_data: Dictionary = saved_resource.resource.get_save_state()
			output_dict[category][saved_resource_name] = serialized_data
	
	var file: FileAccess = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_string(serialize(output_dict))
	file.close()
	# for resource in get_saved_resources():
	# 	var folder_path := base_path.path_join(resource.category)
	# 	var file_path := folder_path.path_join("%s.tres" % resource.name)
	# 	DirAccess.make_dir_recursive_absolute(folder_path)
	# 	ResourceSaver.save(resource.resource, file_path, ResourceSaver.FLAG_CHANGE_PATH)

func load_from_filesystem() -> void:
	if not try_load_from_filesystem():
		push_error("Could not load from filesystem.")

func _try_load_from_dict(save_data: Dictionary) -> bool:
	var saved_resources := get_saved_resources()
	
	for category: String in save_data.keys():
		var saved_category_dict: Dictionary = save_data[category]
		var saved_resources_in_category: Dictionary[String, SavedResource] = saved_resources[category]
		if not saved_resources_in_category:
			push_error("Category \"%s\" in SaveFile not found in SaveFile. Maybe corrupted? Skipping..." % category)
			continue
		
		for saved_resource_name: String in saved_category_dict.keys():
			if saved_resource_name not in saved_resources_in_category:
				push_warning("Resource \"%s\" in category \"%s\" not found in SaveFile. Maybe new resource? Skipping..." % [
					saved_resource_name,
					category
				])
				continue

			var saved_resource_data: Dictionary = saved_category_dict[saved_resource_name]
			var saved_resource: SavedResource = saved_resources_in_category[saved_resource_name]
			saved_resource.resource.load_save_state(saved_resource_data)
	return true

func try_load_from_filesystem() -> bool:
	var file := FileAccess.open(file_path, FileAccess.READ)
	if not file:
		return false
	var file_content: String = file.get_as_text()
	file.close()
	var save_data: Dictionary = deserialize(file_content)
	if not save_data:
		push_error("Failed to parse save file JSON at path \"%s\": %s" % [file_path, save_data.error_string])
		return false
	return _try_load_from_dict(save_data)
	
func delete_from_filesystem() -> void:
	var globalized_file_path := ProjectSettings.globalize_path(file_path)
	if FileAccess.file_exists(globalized_file_path):
		DirAccess.remove_absolute(globalized_file_path)
