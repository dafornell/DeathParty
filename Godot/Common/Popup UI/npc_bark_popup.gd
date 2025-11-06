class_name Bark3D extends Node3D

@export var bark_tail: TextureRect
@export var bark_board: Panel
@export var bark_text: Label
@export var bark_bubble: Sprite3D
@export var bark_interact: Sprite3D

var activated_bark: bool = false
var board_padding: float = 35
var default_bark_speed: float = .9
var reset_delay: float = 2

func _process(_delta: float) -> void:
	match_board_size_to_text()


func set_bark_text(bark: String) -> void:
	bark_text.text = bark


func match_board_size_to_text() -> void:
	bark_board.custom_minimum_size.x = bark_text.size.x + board_padding


func activate_bark() -> void:
	activated_bark = true
	bark_interact.visible = false
	bark_bubble.visible = true
	animate_bark_text("this is a test bark barking bark bark test")
	pass


func animate_bark_text(bark: String, bark_speed: float = default_bark_speed, r_delay: float = -1) -> void:
	bark_text.visible_ratio = 0
	set_bark_text(bark)
	var tween: Tween = create_tween()
	tween.tween_property(bark_text, "visible_ratio", 1, bark_speed)
	if(r_delay != -1):
		reset_delay = r_delay
	else:
		reset_delay = calculate_reading_time()
	tween.tween_callback(reset_bark).set_delay(reset_delay)


func calculate_reading_time() -> float:
	var words: float = bark_text.get_total_character_count() / 5.4 # average about 5.4 letters per word
	var time_to_read: float = words / 2.5  # assume a reading rate of 2.5 words/s
	return time_to_read * 2 # allow time to read the text this many times


func reset_text() -> void:
	set_bark_text("")


func reset_bark() -> void:
	reset_text()
	bark_bubble.visible = false
	bark_interact.visible = true
	activated_bark = false
	visible = false
