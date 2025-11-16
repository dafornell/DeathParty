class_name DialogueLineExpand extends DialogueLine

@export var control_to_resize : Control
@export var chat_backer : PanelContainer
@export var minimum_y_size : float = 0
var resize_control : ResizableControl

func _ready() -> void:
	assert(chat_backer)
	var stylebox := chat_backer.get_theme_stylebox(&"panel")
	var padding_x := stylebox.content_margin_left + stylebox.content_margin_right
	var padding_y := stylebox.content_margin_top + stylebox.content_margin_bottom
	resize_control = ResizableControl.new(control_to_resize, Text)
	resize_control.padding_horizontal = padding_x
	resize_control.padding_bottom = padding_y
	resize()
	print("Custom minimum size: ", self.control_to_resize.custom_minimum_size.y)
	custom_minimum_size.y = self.control_to_resize.custom_minimum_size.y

func _on_text_resized() -> void:
	print("On text resized: ", control_to_resize.name)
	if resize_control:
		resize()

func resize() -> void:
	resize_control.resize()
	resize_control.resize_component(chat_backer)
	self.control_to_resize.custom_minimum_size.y = max(self.control_to_resize.custom_minimum_size.y, minimum_y_size)
