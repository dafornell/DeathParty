class_name InventoryItemResource extends DefaultResource

@export var description : String
@export var model : PackedScene

@export var amount_owned : int = 0
@export var dialogue_on_first_view : InkResource
var viewed : bool = false

func get_save_state() -> Dictionary:
	return {
		"amount_owned": amount_owned,
		"viewed": viewed,
	}

func load_save_state(save_data: Dictionary) -> void:
	amount_owned = save_data.get("amount_owned", 0)
	viewed = save_data.get("viewed", false)
