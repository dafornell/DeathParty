@tool
class_name InputIndicator extends Control

@export var icon_map: InputIconMap = null

@export_group("Node references")
@export var key_texture_rect_container: Control
@export var key_texture_rect: TextureRect

@export var key_label_container: Control
@export var key_label: Label

@export var description_label: Label

@export_group("Display")
@export var description_text: String:
	set(v):
		description_text = v
		if description_label:
			description_label.text = v

enum DisplayType {
	ACTION = 0,
	COMPOSITE_ACTION = 1,
	STRING = 2,
	NOTHING = 3,
}

@export var display_type: DisplayType = DisplayType.ACTION:
	set(v):
		if display_type == v: return
		display_type = v
		notify_property_list_changed()
		_update_key_icon()

var action_name: StringName:
	set(v):
		if action_name == v: return
		action_name = v
		_update_key_icon()

var composite_action_names: Array[StringName] = []:
	set(v):
		composite_action_names = v
		_update_key_icon()
	
var composite_action_delimiter: String = "":
	set(v):
		composite_action_delimiter = v
		_update_key_icon()

var key_string: String = "":
	set(v):
		key_string = v
		_update_key_icon()

var regex := RegEx.new()

func _init() -> void:
	regex.compile("[^(]*( \\(.*\\))?")
	
func _ready() -> void:
	_update_key_icon()

func _get_property_list() -> Array[Dictionary]:
	var actions: Array[String] = []
	# Load actions from project settings (if not already loaded)
	InputMap.load_from_project_settings() 
	for action in InputMap.get_actions():
		actions.append(str(action)) # Convert StringName to String for hint_string

	var hint_string: String = ",".join(actions)

	var properties: Array[Dictionary] = []
	if display_type == DisplayType.ACTION:
		properties.append({
			"name": "action_name",
			"type": TYPE_STRING_NAME,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": hint_string
		})
	elif display_type == DisplayType.COMPOSITE_ACTION:
		properties.append({
			"name": "composite_action_names",
			"type": TYPE_ARRAY,
			"hint": PROPERTY_HINT_TYPE_STRING,
			"hint_string": "%d/%d:%s" % [
				TYPE_STRING_NAME,
				PROPERTY_HINT_ENUM,
				",".join(actions)
			]
		})
		properties.append({
			"name": "composite_action_delimiter",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_NONE,
		})
	elif display_type == DisplayType.STRING:
		properties.append({
			"name": "key_string",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_NONE,
		})
	return properties

func _is_input_event_suitable(_ev: InputEvent) -> bool:
	# can be updated to choose which input event to show for
	# given actions
	# eg. to check if the input device is correct if we support controller
	return true

func _get_display_string_icon(string: String) -> Texture:
	if icon_map:
		return icon_map.map.get(string)
	return null

func _get_display_string(ev: InputEvent) -> String:
	var re_match := regex.search(ev.as_text())
	if re_match == null:
		return ""
	var key := re_match.strings[0]
	return key.strip_edges()

func _get_display_string_from_action(action: StringName) -> String:
	var display_string: String
	var input_events := InputMap.action_get_events(action)
	for ev in input_events:
		if !_is_input_event_suitable(ev):
			continue
		display_string = _get_display_string(ev)
		break
	return display_string

func _update_key_icon() -> void:
	# if we are before _ready, we don't have access to exported variables
	# this is a problem, so just don't do anything and wait for _ready to
	# call _update_key_icon
	if !is_node_ready(): return
	if display_type == DisplayType.NOTHING:
		key_texture_rect.texture = null
		key_texture_rect_container.visible = false
		key_label.text = ""
		key_label_container.visible = false
		return
	
	var display_string: String
	if display_type == DisplayType.STRING:
		display_string = "" if key_string == null else key_string
	elif display_type == DisplayType.ACTION:
		display_string = _get_display_string_from_action(action_name)
	elif display_type == DisplayType.COMPOSITE_ACTION:
		if composite_action_names == null:
			composite_action_names = []
		if composite_action_delimiter == null:
			composite_action_delimiter = ""
		display_string = composite_action_delimiter.join(
			composite_action_names.map(_get_display_string_from_action)
		)
	var icon := _get_display_string_icon(display_string)
	if icon:
		key_texture_rect.texture = icon
		key_texture_rect_container.visible = true
		key_label.text = ""
		key_label_container.visible = false
	else:
		key_texture_rect.texture = null
		key_texture_rect_container.visible = false
		key_label.text = display_string
		key_label_container.visible = true
