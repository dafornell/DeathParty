extends Room3D


@export var locked_door: Interactable
@export var unlocked_door: SceneLoader


func _ready() -> void:
	super()
	body_entered.connect(handle_player_entrance)
	SaveSystem.inventory_changed.connect(check_if_player_has_storage_room_key)


func handle_player_entrance(body: Node3D) -> void:
	remove_all_bounds(body)
	rotate_player(body)

	keep_camera_on_player(body)
	bind_camera_LR(body)
	bind_camera_y(body)

	check_if_player_has_storage_room_key()


func check_if_player_has_storage_room_key() -> void:
	if SaveSystem.get_inventory_item("Key").amount_owned > 0:
		locked_door.enabled = false
		unlocked_door.enabled = true
	else:
		locked_door.enabled = true
		unlocked_door.enabled = false
