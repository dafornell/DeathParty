class_name ContactPanel extends Control

@export var contact_button : Button
@export var name_label : RichTextLabel
@export var time_label : RichTextLabel
@export var message_label : RichTextLabel
@export var image_label : TextureRect
@export var notification_badge : PhoneNotificationBadge

var message_app : MessageAppBox
var contact : ChatResource

func on_pressed() -> void:
	message_app.on_contact_press(contact)

func on_unread(_active : bool) -> void:
	message_label.text = "[color=black]"+contact.display_message+"[/color]"

func _ready() -> void:
	contact_button.pressed.connect(on_pressed)
	contact.unread.connect(on_unread)
	name_label.text = "[color=black]"+contact.name+"[/color]"
	message_label.text = "[color=black]"+contact.display_message+"[/color]"
	if contact.image != null:
		image_label.texture = contact.image
	notification_badge.chat_resource = contact
