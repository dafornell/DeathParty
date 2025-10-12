class_name ObjectViewerRotatable extends ObjectViewerInteractable

var dragging : bool = false

# rotate to face the camera
const START_ROTATION = Vector3(deg_to_rad(90), deg_to_rad(180), 0)

func _ready() -> void:
	print("Object viewer rotatatble")
	self.rotation = START_ROTATION
	Interact.mouse_position_changed.connect(on_mouse_pos_changed)

func on_mouse_pos_changed(delta : Vector2):
	if !dragging:
		return
	self.rotate_x(delta.y * 0.005)
	self.rotate_y(delta.x * 0.005)

##INHERITED
func on_mouse_down() -> void:
	dragging = true
	
func on_mouse_up() -> void:
	dragging = false
