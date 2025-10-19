@tool
extends Control

@export var base_minimum_size := Vector2.ZERO
@export var rt_label: RichTextLabel
@export var increment := 64

var last_text_length := 0

var redraws_this_frame := 0

const MAX_REDRAWS_PER_FRAME := 20

func _ready() -> void:
    rt_label.finished.connect(_on_text_changed)

func _on_text_changed() -> void:
    var text_len := rt_label.get_total_character_count()
    if text_len < last_text_length:
        custom_minimum_size = base_minimum_size
        queue_redraw()
    elif not _is_text_fully_visible():
        queue_redraw()
    else:
        last_text_length = text_len

func _increase_minimum_size() -> void:
    custom_minimum_size.y += increment

func _is_text_fully_visible() -> bool:
    var content_size := Vector2(
        rt_label.get_content_width(),
        rt_label.get_content_height()
    )
    return content_size.y <= rt_label.size.y

func _draw() -> void:
    if _is_text_fully_visible():
        last_text_length = rt_label.get_total_character_count()
        return
    
    _increase_minimum_size()

func _process(_delta: float) -> void:
    redraws_this_frame = 0
    if not _is_text_fully_visible():
        _increase_minimum_size()