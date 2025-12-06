class_name PlayerData extends DefaultResource

#This will be dynamically added to with Ink
var variable_dict : Dictionary[String, Variant] = {
	time = 22.0,
	intelligence = 10,
	strength = 10,
	empathy = 10,
	sleaziness = 10,
	basement_tape_cleared = false
}

var journal_entries : Dictionary[String, bool] = {}
var tasks : Array[String] = []

var extra_data: Dictionary[String, Variant] = {}

func get_save_state() -> Dictionary:
	return {
		"variable_dict": variable_dict,
		"journal_entries": journal_entries,
		"tasks": tasks,
		"extra_data": extra_data,
	}

func load_save_state(save_data: Dictionary) -> void:
	var saved_variable_dict: Dictionary = save_data.get("variable_dict", {})
	var saved_journal_entries: Dictionary = save_data.get("journal_entries", {})
	var saved_tasks: Array = save_data.get("tasks", [])
	var saved_extra_data: Dictionary = save_data.get("extra_data", {})

	variable_dict.assign(saved_variable_dict)
	journal_entries.assign(saved_journal_entries)
	tasks.assign(saved_tasks)
	extra_data.assign(saved_extra_data)
