# special instance of Interactable that starts disabled until
# the tutorial emits Events.interactables_enabled
# so that the player cannot pick up the polaroid until a certain state
# in the tutorial
extends Interactable

func _ready() -> void:
	enabled = false
	super()
	Events.interactables_enabled.connect(_on_interactables_enabled, CONNECT_ONE_SHOT)

func _on_interactables_enabled() -> void:
	enabled = true

func on_interact() -> void:
	super()
	if not enabled: return;
	Events.collected_polaroid.emit()
