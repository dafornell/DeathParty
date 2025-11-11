extends CanvasLayer


@export var title_image: TextureRect
@onready var music: FmodEventEmitter3D = %Music


@onready var click_sound: FmodEventEmitter3D = %ClickSound
@onready var hover_sound: FmodEventEmitter3D = %HoverSound


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GuiSystem.in_title_screen = true
	#if ContentLoader.active_scene == null:
		#await ContentLoader.finished_loading
		#if ContentLoader.active_scene.name != "Bedroom":
			#FmodServer.set_global_parameter_by_name("InTitleScreen", 0)

	var all_buttons: Array[Node] = find_children("*", "Button", true, false)
	for button: Button in all_buttons:
		button.pressed.connect(_on_any_button_pressed)
		button.mouse_entered.connect(_on_any_button_hovered)


func _exit_tree() -> void:
	GuiSystem.in_title_screen = false


func _on_settings_button_pressed() -> void:
	Events.title_screen_settings_button_pressed.emit()


func _on_quit_button_pressed() -> void:
	Events.title_screen_quit_button_pressed.emit()


func _on_start_game_button_pressed() -> void:
	for button: Button in find_children("*", "Button"):
		button.hide()

	var tween: Tween = get_tree().create_tween()
	tween.tween_property(title_image, "modulate:a", 0, 1.3)

	await tween.finished

	hide()
	Events.title_screen_start_game_button_pressed.emit()
	GuiSystem.in_title_screen = false


func _on_any_button_pressed() -> void:
	click_sound.play()


func _on_any_button_hovered() -> void:
	hover_sound.play()
