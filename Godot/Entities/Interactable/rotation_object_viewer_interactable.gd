class_name ObjectViewerRotatable extends ObjectViewerInteractable

@export var mesh_root: Node3D

var dragging : bool = false

const ROTATE_SENSITIVITY := 0.005

func _ready() -> void:
	Interact.mouse_position_changed.connect(on_mouse_pos_changed)

func add_item_to_viewer(item: Node3D) -> void:
	print(item.rotation)
	var orig_rotation := item.rotation
	mesh_root.add_child(item)
	item.rotation = orig_rotation

func on_mouse_pos_changed(delta : Vector2) -> void:
	if !dragging:
		return
	mesh_root.rotate_x(delta.y * ROTATE_SENSITIVITY)
	mesh_root.rotate_y(delta.x * ROTATE_SENSITIVITY)


##INHERITED
func on_mouse_down() -> void:
	dragging = true


func on_mouse_up() -> void:
	dragging = false
