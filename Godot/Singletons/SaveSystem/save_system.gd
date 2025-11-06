extends Node

@export var blank_save_file: SaveFile

var active_save_file : SaveFile
var player_data: PlayerData:
	get: 
		return active_save_file.player_data

var data: Dictionary:
	get: return player_data.extra_data

const save_file_location := "user://save.tres"

signal time_changed
signal inventory_changed(addremove: String, item: InventoryItemResource)
signal tasks_changed
signal pre_save
signal loaded

func _ready() -> void:
	load_from_disk()

func save_to_disk() -> void:
	pre_save.emit()
	active_save_file.save_to_filesystem()

func _init_save_file() -> void:
	active_save_file = blank_save_file.duplicate(true)
	active_save_file.load_from_resources()

func create_new_save() -> void:
	_init_save_file()
	save_to_disk()
	loaded.emit()

func load_from_disk() -> void:
	_init_save_file()
	active_save_file.try_load_from_filesystem()
	loaded.emit()

func load_inventory() -> void: 
	# Make sure player has an entry for each possible item
	# add in any new items
	for item_name: String in active_save_file.inventory_items:
		if not player_data.journal_entries.has(item_name):
			player_data.journal_entries[item_name] = false

#TYPE SAFETY
func key_exists(key:String) -> bool: # returns whether key exists
	return player_data.variable_dict.has(key)

func key_exists_assert(key:String) -> void: # returns location of key & errors if it doesn't exist
	assert(key_exists(key), "ERROR: invalid key '" + key + "'. Check your spelling!")

func key_is_type(key:String, type:int, value:Variant) -> void: # errors if types don't match (passing type enum)
	key_exists_assert(key)
	assert(typeof(player_data.variable_dict[key])==type, "TYPE ERROR: " + key + " (current value: " + str(player_data.variable_dict[key]) + ") not of type " + str(type) + " (current value: " + str(value) + ")")

func match_type(key:String, value:Variant) -> void: # errors if types don't match (passing new value)
	key_is_type(key, typeof(value), value)

#Mapping names to resources
func get_character(char_name : String) -> CharacterResource:
	if !active_save_file.characters.has(char_name):
		return null
	return active_save_file.characters[char_name]

func get_talking_object(obj_name : String) -> TalkingObjectResource:
	if !active_save_file.talking_objects.has(obj_name):
		return null
	return active_save_file.talking_objects[obj_name]

func get_phone_chat(phone_chat_name : String) -> ChatResource:
	if !active_save_file.phone_chats.has(phone_chat_name):
		return null
	return active_save_file.phone_chats[phone_chat_name]

func get_inventory_item(item_name : String) -> InventoryItemResource:
	if !active_save_file.inventory_items.has(item_name):
		return null
	return active_save_file.inventory_items[item_name]

##QUICK-ACCESS VALUES
func get_time() -> float:
	return get_key("time")

func get_time_string(include_ampm:bool = true) -> String:
	return parse_time(get_time(), include_ampm)

#EDITING
func get_key(key:String) ->  Variant:
	key_exists_assert(key)
	print("global decl GET key function: ", key, " | ", player_data.variable_dict[key])
	return player_data.variable_dict[key]

func set_key(key:String, value:Variant) -> void:
	if key_exists(key):
		match_type(key, value) # asserts that they are of matching types
	if value is String:
		if value == "true":
			value = true
		elif value == "false":
			value = false
	print("set key function: ", key, " value: ", value)
	player_data.variable_dict[key] = value
	
func increment(key:String) -> void:
	set_key(key, player_data.variable_dict[key]+1) #will also emit signal

func decrement(key:String) -> void:
	set_key(key, player_data.variable_dict[key]-1)

#INVENTORY
func item_exists(item_name:String) -> InventoryItemResource:
	assert(active_save_file.inventory_items.has(item_name), "ERROR: no such item '" + item_name + "'. Check your spelling!")
	return active_save_file.inventory_items[item_name]

func add_item(item_name:String, show_item_details : bool = false) -> void:
	if item_name == "Journal": return
	var item := item_exists(item_name)
	item.amount_owned += 1
	inventory_changed.emit("add", item)
	if show_item_details and item.model != null:
		InventoryUtils.show_inventory_item_details(item)

func remove_item(item_name:String) -> bool: #returns 1 if successful, 0 if there aren't any left
	var item := item_exists(item_name)
	if item.amount_owned > 0:
		item.amount_owned -= 1
		inventory_changed.emit("remove", item)
		return true
	else:
		return false
		
func item_count(item_name:String) -> int:
	var item := item_exists(item_name)
	return item.amount_owned

func get_inventory() -> Dictionary[String, InventoryItemResource]:
	return active_save_file.inventory_items
	
#TASKS
func task_exists(item:String) -> TaskResource:
	assert(active_save_file.tasks.has(item), "ERROR: no such task '" + item + "'. Check your spelling!")
	return active_save_file.tasks[item]
	
func add_task(item:String) -> void:
	print("Added task: ", item)
	task_exists(item)
	player_data.tasks.push_back(item)
	tasks_changed.emit("add", item)

func complete_task(item:String) -> void: #returns 1 if successful, 0 if there aren't any left
	task_exists(item)
	tasks_changed.emit("complete", item)
	
#JOURNAL ENTRIES
func is_journal_entry_active(entry_name:String) -> bool:
	return player_data.journal_entries[entry_name]

func set_journal_entry(entry_name:String, active:bool) -> void:
	player_data.journal_entries[entry_name] = active
		
#PARSE TIME
func parse_time(value : float, include_ampm : bool = true) -> String:
	var am_pm : String = " a.m."
	var hour : int = int(value)%24
	var minutes : int = int((value - hour)*60)%60 #isolate decimal
	var mins_string : String = str(minutes)
	if hour == 0:
		hour = 12
		am_pm = " a.m."
	elif hour > 12:
		hour -= 12
		am_pm = " p.m."
	
	if minutes == 0:
		mins_string = "00"
	elif minutes < 10:
		mins_string = "0"+mins_string
	
	if include_ampm:
		return str(hour) + ":" + mins_string + am_pm
	else:
		return str(hour) + ":" + mins_string
