extends TutorialState

@export var highlight: TutorialHighlight
@export var highlight_size_mult: float
@export var open_journal_state: TutorialState

func enter_state() -> void:
	super()
	Events.close_inventory.connect(transition)
	Events.journal_closed.connect(_on_journal_closed)
	highlight.size_mult = highlight_size_mult

func exit_state() -> void:
	Events.close_inventory.disconnect(transition)
	Events.journal_closed.disconnect(_on_journal_closed)
	highlight.target_node_3d = null
	highlight.size_mult = highlight.default_size_mult
	super()

func _on_journal_closed() -> void:
	transition(open_journal_state)
	highlight.target_node_3d = null
