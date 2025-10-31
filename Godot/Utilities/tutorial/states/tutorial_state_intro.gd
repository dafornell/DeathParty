extends TutorialState

func _ready() -> void:
	Events.intro_finished.connect(transition)

func _process(_delta: float) -> void:
	if Globals.player:
		Globals.player.movement_disabled = true
		process_mode = Node.PROCESS_MODE_DISABLED
	
func exit_state() -> void:
	Globals.player.movement_disabled = false
	super()
