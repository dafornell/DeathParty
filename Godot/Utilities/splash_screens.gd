extends CanvasLayer


@onready var background: ColorRect = %Background
@onready var sunday_logo: TextureRect = %SundayLogo
@onready var fmod_logo: TextureRect = %FmodLogo


func _enter_tree() -> void:
	if OS.has_feature("editor"):
		queue_free()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(sunday_logo, "modulate:a", 1, 1)
	tween.tween_interval(1)
	tween.tween_property(sunday_logo, "modulate:a", 0, 1)

	tween.tween_interval(0.5)

	tween.tween_property(fmod_logo, "modulate:a", 1, 1)
	tween.tween_interval(1)
	tween.tween_property(fmod_logo, "modulate:a", 0, 1)

	tween.tween_property(background, "color:a", 0, 1)

	await tween.finished
	queue_free()
