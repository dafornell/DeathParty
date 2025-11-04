extends TutorialState

@export var walk_timer: float = 3.0

func enter_state() -> void:
	super()
	Globals.player.movement_disabled = false

func _process(_delta: float) -> void:
	if Globals.player.player_velocity != Vector3.ZERO:
		_transition_after_delay()
		process_mode = Node.PROCESS_MODE_DISABLED # stop _process

func _transition_after_delay() -> void:
	await get_tree().create_timer(walk_timer).timeout
	transition()
