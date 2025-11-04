extends ObjectViewerInteractable

@export var animation_player: AnimationPlayer
@export var default_animation: StringName
@export var hovered_animation: StringName

func _ready() -> void:
	animation_player.play(default_animation)

func on_mouse_down() -> void:
	if GuiSystem.inventory_showing:
		Events.close_inventory.emit()
	else:
		Events.open_inventory.emit()

func enter_hover() -> void:
	animation_player.play(hovered_animation)

func exit_hover() -> void:
	animation_player.play(default_animation)
