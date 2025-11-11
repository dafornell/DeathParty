class_name DevSettings extends Object

static var config: ConfigFile = null

const _save_location: String = "user://dev_settings.cfg"
const _global_section_key := "GLOBAL"

static func ensure_loaded() -> void:
	if config == null:
		load_from_filesystem()

static func load_from_filesystem() -> void:
	config = ConfigFile.new()
	
	var status := config.load(_save_location)
	if status not in [OK, ERR_FILE_NOT_FOUND]:
		push_error("Unexpected error loading dev settings: %s" % status)

static func save_to_filesystem() -> void:
	config.save(_save_location)
