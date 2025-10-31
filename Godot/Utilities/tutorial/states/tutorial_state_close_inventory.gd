extends TutorialState

@export var highlight: TutorialHighlight
@export var open_journal_state: TutorialState

func enter_state() -> void:
	super()
	Events.close_inventory.connect(transition)
	Events.journal_closed.connect(_on_journal_closed)

func exit_state() -> void:
	Events.close_inventory.disconnect(transition)
	Events.journal_closed.disconnect(_on_journal_closed)
	highlight.target_node_3d = null
	super()

func _on_journal_closed() -> void:
	transition(open_journal_state)
	highlight.target_node_3d = null
