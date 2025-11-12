class_name DefaultResource extends Resource

@export var name : String

##OVERRIDABLE FUNCTIONS
func initialize() -> void: #gets called when loaded by SaveSystem
	pass

@warning_ignore("unused_parameter")
func load_save_state(save_data: Dictionary) -> void:
	pass

func get_save_state() -> Dictionary:
	return {}

func path_to_json(path: Variant) -> JSON:
	if path == null: return null
	var path_string: String = path
	assert(path_string != null)
	return ResourceLoader.load(path_string)

func json_to_path(json: JSON) -> Variant:
	if json == null: return null
	assert(not json.resource_path.is_empty())
	return json.resource_path
