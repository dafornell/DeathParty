class_name PhoneNotificationBadge extends Node

@export var modulate_root: Control
@export var chat_resource: ChatResource:
	set(v):
		if v == chat_resource: return
		_disconnect_signals()
			
		chat_resource = v
		if chat_resource != null:
			chat_resource.unread.connect(_on_chat_resource_unread)
		else:
			Events.new_phone_message.connect(_on_new_phone_message)

var badge_visible: bool:
	set(v):
		if v:
			_show_badge()
		else:
			_hide_badge()

func _disconnect_signals() -> void:
	if chat_resource != null:
		if chat_resource.unread.is_connected(_on_chat_resource_unread):
			chat_resource.unread.disconnect(_on_chat_resource_unread)
			
	if Events.new_phone_message.is_connected(_on_new_phone_message):
		Events.new_phone_message.disconnect(_on_new_phone_message)

func _ready() -> void:
	if chat_resource == null:
		Events.new_phone_message.connect(_on_new_phone_message)
	else:
		chat_resource.unread.connect(_on_chat_resource_unread)
	_hide_badge()

func _on_chat_resource_unread(unread: bool) -> void:
	badge_visible = unread

func _on_new_phone_message(_new_chat_resource: ChatResource) -> void:
	if chat_resource: return
	_show_badge()

func _show_badge() -> void:
	modulate_root.modulate.a = 1

func _hide_badge() -> void:
	modulate_root.modulate.a = 0
