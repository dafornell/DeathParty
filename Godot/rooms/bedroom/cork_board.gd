extends Interactable

@export var take: Node3D
@export var title: CanvasLayer

func _ready() -> void:
	super()
	Events.collected_polaroid.connect(_on_collected_polaroid)

func on_interact() -> void:
	# NOTE: this kind of confused me because i couldn't get this interactable
	#		to respect whether it was enabled or not, and i think it was
	#		because the `if !enabled: return` in the interactable class wasn't
	#		stopping this object specific stuff below from executing even if it
	#		was disabled - it only seems to behave correctly if i add this
	#		enabled check here too 💭
	#				- jack
	if !enabled: return
	super ()
	title.visible = false
	Globals.polaroid_camera_ui.visible = true
	# TODO: create a global in_polaroid_camera variable, maybe with a setter
	#		function to handle enabling/disabling movement while player is
	#		using camera globally instead of doing it here
	if Globals.polaroid_camera_ui.visible == true:
		Globals.player.movement_disabled = true
	print("camera scene should be on")
	enabled = false


func _on_collected_polaroid() -> void:
	enabled = true
