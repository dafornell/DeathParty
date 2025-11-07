extends CanvasLayer


@export var title_image: TextureRect
@onready var music: FmodEventEmitter3D = %Music


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GuiSystem.in_title_screen = true
	#if ContentLoader.active_scene == null:
		#await ContentLoader.finished_loading
		#if ContentLoader.active_scene.name != "Bedroom":
			#FmodServer.set_global_parameter_by_name("InTitleScreen", 0)


func _on_settings_button_pressed() -> void:
	Events.title_screen_settings_button_pressed.emit()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_start_game_button_pressed() -> void:
	for button: Button in find_children("*", "Button"):
		button.hide()

	var tween: Tween = get_tree().create_tween()
	tween.tween_property(title_image, "modulate:a", 0, 1.3)

	await tween.finished

	hide()
	Events.title_screen_start_game_button_pressed.emit()
	GuiSystem.in_title_screen = false
