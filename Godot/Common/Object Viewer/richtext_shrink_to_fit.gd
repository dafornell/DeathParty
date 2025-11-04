extends RichTextLabel

@export var target_width: int = 512

# only shrink once
var shrank: bool = false

func _ready() -> void:
	finished.connect(_on_finished)


func _on_finished() -> void:
	shrank = false
	custom_minimum_size = Vector2i(target_width, 0)
	queue_redraw()


# must be on draw so that we wait until
# the RichTextLabel draws (otherwise get_visible_content_rect is 0)
func _draw() -> void:
	if shrank: return
	shrank = true
	print("richtext_shrink_to_fit: setting custom minimum size to: ", get_visible_content_rect().size )
	custom_minimum_size = get_visible_content_rect().size + Vector2i(4, 4) # add some padding just in case
