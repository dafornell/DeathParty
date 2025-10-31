extends TutorialState

@export var highlight: TutorialHighlight
@export var highlight_size_mult: float = 1
@export var open_journal_state: TutorialState

func enter_state() -> void:
	super()
	Events.open_inventory.connect(transition)
	Events.journal_closed.connect(_on_journal_closed)
	var toggle_inventory_button := GuiSystem.journal_instance.toggle_inventory_button
	highlight.target_node_3d = toggle_inventory_button
	highlight.set_size_mult_instant(highlight_size_mult)

func exit_state() -> void:
	Events.open_inventory.disconnect(transition)
	Events.journal_closed.disconnect(_on_journal_closed)
	super()

func _on_journal_closed() -> void:
	transition(open_journal_state)
	highlight.target_node_3d = null
