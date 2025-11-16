extends Interactable

@export var take: Node3D
@export var polaroid_scene: PackedScene

func _ready() -> void:
	super()
	Events.ready_to_take_photo_of_corkboard.connect(_on_ready_to_take_photo_of_corkboard)

func on_interact() -> void:
	if !enabled: return
	super()
	
	Globals.polaroid_camera_ui.open_with_scene_from_packed(polaroid_scene)
	enabled = false

func _on_ready_to_take_photo_of_corkboard() -> void:
	enabled = true
