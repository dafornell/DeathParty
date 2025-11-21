extends CanvasLayer


@export var timer: Timer
@export var popup: PanelContainer
@export var sound: FmodEventEmitter2D

var tween_offset := 25
var tween_duration := 0.5


func _enter_tree() -> void:
	Events.tasks_updated.connect(_on_tasks_updated)


func _on_tasks_updated() -> void:
	popup.modulate.a = 0
	popup.position.y += tween_offset
	show()
	timer.start()
	var t: Tween = create_tween()
	t.tween_property(popup, "position:y", popup.position.y - tween_offset, tween_duration)
	t.parallel().tween_property(popup, "modulate:a", 1, tween_duration)
	sound.play()


func _on_timer_timeout() -> void:
	var t: Tween = create_tween()
	t.tween_property(popup, "position:y", popup.position.y + tween_offset, tween_duration)
	t.parallel().tween_property(popup, "modulate:a", 0, tween_duration)
	await t.finished
	hide()
