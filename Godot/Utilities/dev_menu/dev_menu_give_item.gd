extends Control

@export var line_edit: LineEdit
@export var status_text: Label

var _status_timer: SceneTreeTimer = null

func _ready() -> void:
	line_edit.text_submitted.connect(_on_line_edit_submitted)
	line_edit.text_changed.connect(_on_line_edit_text_changed)
	_hide_status()

func _on_line_edit_text_changed(new_text: String) -> void:
	var old_caret := line_edit.caret_column
	line_edit.text = new_text.replace("`", "")
	line_edit.caret_column = min(old_caret, line_edit.text.length())

func _on_line_edit_submitted(_new_text: String) -> void:
	_on_give_item_pressed()

func _on_give_item_pressed() -> void:
	var item_name: String = line_edit.text.strip_edges()
	if item_name == "":
		return
	line_edit.text = ""
	
	if not SaveSystem.active_save_file.inventory_items.has(item_name):
		push_error("Item not found in inventory: " + item_name)
		_show_status("Item not found: " + item_name, true)
		return
	SaveSystem.add_item(item_name)
	_show_status("Gave item: " + item_name)

func _show_status(message: String, error: bool = false) -> void:
	status_text.text = message
	status_text.visible = true

	# set color
	if error:
		status_text.add_theme_color_override("font_color", Color.RED)
	else:
		status_text.remove_theme_color_override("font_color")
	
	# set disappear timer
	var this_status_timer := get_tree().create_timer(5.0)
	_status_timer = this_status_timer
	await _status_timer.timeout
	if _status_timer == this_status_timer:
		_hide_status()

func _hide_status() -> void:
	status_text.visible = false
