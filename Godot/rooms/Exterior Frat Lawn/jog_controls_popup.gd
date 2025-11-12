extends CanvasLayer

@export var tween_duration := 0.1
@export var show_duration := 5.0
@export var input_indicator: Control

const SAVE_KEY := "jog_controls_shown"

func _ready() -> void:
	if not SaveSystem.data.get(SAVE_KEY, false):
		_show_indicator()

func _show_indicator() -> void:
	if GuiSystem.in_title_screen:
		await Events.title_screen_start_game_button_pressed
	
	show()
	
	input_indicator.modulate.a = 0
	var tween := get_tree().create_tween()
	tween.tween_property(input_indicator, "modulate:a", 1, tween_duration)
	await tween.finished
	
	await get_tree().create_timer(show_duration).timeout
	
	tween = get_tree().create_tween()
	tween.tween_property(input_indicator, "modulate:a", 0, tween_duration)
	await tween.finished
	
	hide()
	SaveSystem.data.set(SAVE_KEY, true)
