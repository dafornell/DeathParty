class_name TaskResource extends DefaultResource

@export var description : String
var assigned : bool = false
var finished : bool = false

var time_updated : float

var gui_node : TaskContainer
var prefab : PackedScene = preload("res://Assets/GUIPrefabs/JournalPrefabs/TaskPrefabs/task_prefab.tscn")

func instantiate() -> TaskContainer:
	assigned = true
	time_updated = SaveSystem.get_key("time")
	gui_node = prefab.instantiate()
	gui_node.task_resource = self
	gui_node.title_label.text = name
	return gui_node

func update() -> void:
	time_updated = SaveSystem.get_key("time")

func complete() -> void:
	finished = true
	print("Task complete: ", name)

func get_save_state() -> Dictionary:
	return {
		"assigned": assigned,
		"finished": finished,
		"time_updated": time_updated,
	}

func load_save_state(save_data: Dictionary) -> void:
	assigned = save_data.get("assigned", false)
	finished = save_data.get("finished", false)
	time_updated = save_data.get("time_updated", 0.0)