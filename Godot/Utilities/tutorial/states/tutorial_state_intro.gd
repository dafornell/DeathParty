extends TutorialState

var _intro_finished := false

func _ready() -> void:
	Events.intro_finished.connect(_on_intro_finished)

func _on_intro_finished() -> void:
	_intro_finished = true
	if active:
		transition()

func _process(_delta: float) -> void:
	if Globals.player:
		Globals.player.movement_disabled = true

func enter_state() -> void:
	super()
	if _intro_finished:
		transition()

func exit_state() -> void:
	Globals.player.movement_disabled = false
	super()
