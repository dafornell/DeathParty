class_name TutorialState extends Node

# control to show/hide on enter/exit (optional)
@export var ui_root: Control
@export var next_state: TutorialState
var active := false

const TWEEN_DURATION := 0.1 

var tween: Tween = null

func _ready() -> void:
	reset()

func transition(to: TutorialState = null) -> void:
	if !to: to = next_state
	exit_state()
	if !to:
		push_warning("TutorialState.transition has no next state")
	else:
		to.enter_state()

func end() -> void:
	exit_state()

func enter_state() -> void:
	print_verbose("Enter tutorial state: " + name)
	if ui_root:
		if tween: tween.kill()
		tween = get_tree().create_tween()
		ui_root.show()
		tween.tween_property(ui_root, "modulate:a", 1, TWEEN_DURATION)
	active = true
	process_mode = Node.PROCESS_MODE_INHERIT

func exit_state() -> void:
	print_verbose("Exit tutorial state: " + name)
	reset()

func reset(immediate: bool = false) -> void:
	if ui_root:
		if tween: tween.kill() 
		if immediate:
			ui_root.modulate.a = 0
			ui_root.visible = false
		else:
			tween = get_tree().create_tween()
			tween.tween_property(ui_root, "modulate:a", 0, TWEEN_DURATION)
			tween.tween_callback(ui_root.hide)
	active = false
	process_mode = Node.PROCESS_MODE_DISABLED
