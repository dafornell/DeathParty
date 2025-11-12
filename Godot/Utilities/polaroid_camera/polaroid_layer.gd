class_name PolaroidLayer extends CanvasLayer

@export var viewfinder_camera: Camera2D

# variable hold the image that the camera is looking at  
@export var picture: TextureRect
@export var shoot: Button
@export var move_speed: float

# since you press E to interact with picture objects,
# we must wait at least a frame to be able to take a picture
var ready_to_take_picture := false

func _ready() -> void:
	Globals.polaroid_camera_ui = self
	# connect deferred so that we call it on the next frame, see ready_to_take_picture
	visibility_changed.connect(_on_visibility_changed, CONNECT_DEFERRED)

func _on_visibility_changed() -> void:
	ready_to_take_picture = visible

# function for movement of camera
func _process(delta: float) -> void:
	if ready_to_take_picture and Input.is_action_just_pressed("take_picture"):
		shoot.pressed.emit()

	_move_picture(delta)
	_clamp_picture_to_bounds()

func _move_picture(delta: float) -> void:
	var move_dir := Input.get_vector(
		"move_left", "move_right",
		"move_up", "move_down"
	)
	var move_delta := move_dir * move_speed * delta
	# subtract b/c we're moving the background, not the camera
	picture.position -= move_delta

func _clamp_picture_to_bounds() -> void:
	@warning_ignore("unsafe_property_access")
	var viewport_size: Vector2 = get_viewport().size
	var lower_bound := viewport_size - picture.size
	picture.position = picture.position.clamp(
		lower_bound,
		Vector2.ZERO,
	)
