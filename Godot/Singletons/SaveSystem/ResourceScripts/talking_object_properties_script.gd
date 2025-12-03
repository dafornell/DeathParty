class_name TalkingObjectResource extends DefaultResource

#CHATS
var upcoming_chats: Array[JSON] = []
var default_chat: JSON

var paused_ink_address: InkAddress

## ORDER: Room-specific -> Everywhere
@export var default_chats: Dictionary[Globals.SCENES, JSON] = {}
@export var queue_chats: Dictionary[Globals.SCENES, JSONArray] = {}

var queue_chat_indices: Dictionary[Globals.SCENES, int] = {}

func get_save_state() -> Dictionary:
	return {
		"upcoming_chats_paths": upcoming_chats.map(json_to_path),
		"queue_chat_indices": queue_chat_indices,
	}

func load_save_state(save_data: Dictionary) -> void:
	var saved_upcoming_chat_paths: Array = save_data.get("upcoming_chats", [])
	var saved_upcoming_chats := saved_upcoming_chat_paths.map(path_to_json)
	var saved_queue_chat_indices: Dictionary = save_data.get("queue_chat_indices", {})
	
	upcoming_chats.assign(saved_upcoming_chats)
	queue_chat_indices = {}
	# can't use assign b/c keys are strings and values are floats
	for scene_index_string: String in saved_queue_chat_indices:
		var queue_chat_index: int = saved_queue_chat_indices[scene_index_string]
		var scene_index := int(scene_index_string)
		queue_chat_indices[scene_index] = queue_chat_index
		
	load_chats_for_room()

signal unread(tf:bool)

func initialize() -> void:
	ContentLoader.finished_loading.connect(load_chats_for_room)
	ContentLoader.switched_scene.connect(func() -> void:
		load_chats_for_room()
	)

var first_chat: JSON:
	get:
		if upcoming_chats.is_empty():
			return null
		else:
			return upcoming_chats.front()

func _load_default_chat(room: Globals.SCENES) -> void:
	if default_chats.has(room) and default_chats[room] != null:
		default_chat = default_chats[room]

func _load_queue_chats(room: Globals.SCENES) -> void:
	if not queue_chats.has(room):
		return
	
	var chats := queue_chats[room].json_array
	var start_index: int = 0
	if queue_chat_indices.has(room):
		start_index = queue_chat_indices[room]
	upcoming_chats.append_array(chats.slice(start_index))
	

func load_chats_for_room() -> void:
	if ContentLoader.active_scene_enum == Globals.SCENES.Nowhere: return
	
	default_chat = null
	upcoming_chats = []

	_load_default_chat(ContentLoader.active_scene_enum)
	_load_default_chat(Globals.SCENES.Everywhere)

	_load_queue_chats(ContentLoader.active_scene_enum)
	_load_queue_chats(Globals.SCENES.Everywhere)

func chat_already_loaded(file : JSON) -> bool:
	for chat: JSON in upcoming_chats:
		if chat.resource_path == file.resource_path:
			return true
	return false

func load_chat(json: JSON) -> void:
	if chat_already_loaded(json):
		return
	upcoming_chats.push_back(json)
	unread.emit(true)
	
func print_all_chats() -> void:
	print(name, "'s chats-------")
	for chat : JSON in upcoming_chats:
		print("Chat: ", chat, chat.resource_path)
	print("------")
	
func start_chat() -> void:
	print("Started chat with ", name, "!", " default chat: ", default_chat, " first chat: ", first_chat)
	#print_all_chats()
	if first_chat == null:
		print("First chat null")
		if default_chat:
			print("Yes default chat")
			DialogueSystem.from_character(self, default_chat)
			Sounds.play_dialogue_start()
	else:
		DialogueSystem.from_character(self, first_chat)
		Sounds.play_dialogue_start()

func _increment_queue_chat_indices(chat: JSON, scene: Globals.SCENES) -> void:
	if queue_chats.has(scene) and chat in queue_chats[scene].json_array:
		var cur_idx: int = queue_chat_indices.get(scene, 0)
		queue_chat_indices[scene] = cur_idx + 1

func end_chat(_current_conversation : Array[InkLineInfo] = []) -> void:
	print("Ended chat with ", name)
	var chat: JSON = upcoming_chats.pop_front()
	_increment_queue_chat_indices(chat, ContentLoader.active_scene_enum)
	_increment_queue_chat_indices(chat, Globals.SCENES.Everywhere)
	

func pause_chat() -> void:
	#save current InkTree address
	paused_ink_address = DialogueSystem.current_address #saves current variables
	
func has_chats() -> bool:
	print("Checking has chats for ", name, " default chat: ", default_chat, " first chat: ", first_chat)
	if default_chat or first_chat != null:
		return true
	else:
		return false
