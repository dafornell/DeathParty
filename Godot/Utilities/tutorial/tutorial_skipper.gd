extends Node

@export var tutorial_ui: TutorialUI
@export var rowan_invite_dialogue: JSON
@export var polaroid_inventory_item: InventoryItemResource

var party_invite_accepted := false
var collected_polaroid := false
var ready_to_take_photo_of_corkboard := false

func _ready() -> void:
	Events.tutorial_skipped.connect(_on_tutorial_skipped)
	
	Events.new_phone_message.connect(_on_new_phone_message)
	Events.party_invite_accepted.connect(_on_party_invite_accepted, CONNECT_ONE_SHOT)
	Events.collected_polaroid.connect(_on_polaroid_collected, CONNECT_ONE_SHOT)
	Events.ready_to_take_photo_of_corkboard.connect(
		_on_ready_to_take_photo_of_corkboard,
		CONNECT_ONE_SHOT
	)

func _on_tutorial_skipped() -> void:
	Globals.player.movement_disabled = false
	if not party_invite_accepted:
		Events.party_invite_accepted.emit()
	if not collected_polaroid:
		SaveSystem.add_item(polaroid_inventory_item.name, true)
		Events.collected_polaroid.emit()
	if not ready_to_take_photo_of_corkboard:
		Events.ready_to_take_photo_of_corkboard.emit()
	
	tutorial_ui.finish_tutorial()

func _on_new_phone_message(chat_resource: ChatResource) -> void:
	pass

func _on_party_invite_accepted() -> void:
	party_invite_accepted = true

func _on_polaroid_collected() -> void:
	collected_polaroid = true

func _on_ready_to_take_photo_of_corkboard() -> void:
	ready_to_take_photo_of_corkboard = true
