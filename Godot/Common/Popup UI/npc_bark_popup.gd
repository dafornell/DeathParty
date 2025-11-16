class_name BarkPopup extends Node3D

signal finished_bark

@export var bark_tail_left: TextureRect
@export var bark_tail_right: TextureRect
@export var bark_board: Panel
@export var bark_text: Label
@export var bark_bubble: Sprite3D
@export var use_left_tail: bool = true

var board_padding: float = 35
var default_bark_speed: float = .5
var reset_delay: float = 2
var estimated_word_length: float = 5.0 # letters per word
var estimated_reading_speed: float = 2.7 # words per second


func _ready() -> void:
	visible = false
	if not use_left_tail:
		bark_tail_left.visible = false
		bark_tail_right.visible = true


func _process(_delta: float) -> void:
	match_board_size_to_text()


func set_bark_text(bark: String) -> void:
	bark_text.text = bark


func match_board_size_to_text() -> void:
	bark_board.custom_minimum_size.x = bark_text.size.x + board_padding


func animate_bark_text(bark: String, bark_speed: float = -1, r_delay: float = -1) -> void:
	visible = true
	bark_text.visible_ratio = 0
	set_bark_text(bark)
	# Time for text to appear
	if(bark_speed != -1):
		bark_speed = bark_speed
	else:
		bark_speed = calculate_text_speed()
	
	var tween: Tween = create_tween()
	tween.tween_property(bark_text, "visible_ratio", 1, bark_speed)
	
	# Time to reset popup
	if(r_delay != -1):
		reset_delay = r_delay
	else:
		reset_delay = calculate_reading_time()
	tween.tween_callback(reset_bark_popup).set_delay(reset_delay)


func calculate_reading_time() -> float:
	var words: float = bark_text.get_total_character_count() / estimated_word_length
	var time_to_read: float = words / estimated_reading_speed
	return time_to_read * 1.2 # allow time to read the text this many times


func calculate_text_speed() -> float:
	var arbitrary_speed_modifier: float = .25
	var final_speed: float = arbitrary_speed_modifier * (bark_text.get_total_character_count() / (estimated_word_length * estimated_reading_speed))
	print(final_speed)
	return final_speed


func reset_text() -> void:
	set_bark_text("")


func reset_bark_popup() -> void:
	reset_text()
	visible = false
	finished_bark.emit()
