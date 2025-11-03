extends Node
## signal bus for sending signals between scenes so they can communicate
## without referencing each other and getting coupled together

# NOTE: sorry for the bad naming conventions on a lot of these lol
#		(if you're adding to this, try to use past tense names for signals
#		like `dialogue_box_text_changed`)
#				- jack


## emitted every time a character is printed to the main dialogue boxes
## (or when new text is loaded by skipping dialogue)
signal dialogue_box_text_changed

## toggle the quest marker on an NPC's interact popup
## - npc_name should match the spelling/capitalisation of the root node of
## the NPC scene AND the name in the character resource
signal toggle_quest_marker(npc_name: String, value: bool)

signal title_screen_start_game_button_pressed
signal title_screen_settings_button_pressed
signal title_screen_quit_button_pressed

signal toggle_dialogue_instructions(value: bool)

signal open_inventory
signal close_inventory

signal new_phone_message(chat_resource: ChatResource)

signal intro_finished
signal party_invite_accepted
signal interactables_enabled

signal phone_opened
signal phone_closed
signal contact_pressed
signal message_app_back_pressed

signal journal_opened
signal journal_closed

signal interaction_area_entered(interactable: Interactable)
signal interaction_area_exited(interactable: Interactable)
signal interacted(interactable: Interactable)

signal collected_polaroid
# emitted by dialogue OliviaDormCamera.ink.json
signal ready_to_take_photo_of_corkboard

signal tutorial_skipped

func _enter_tree() -> void:
	toggle_quest_marker.connect(_on_toggle_quest_marker)


func _on_toggle_quest_marker(npc_name: String, value: bool) -> void:
	var char_resource: CharacterResource = SaveSystem.get_character(npc_name)

	if char_resource != null:
		char_resource.quest_marker_enabled = value
	else:
		print("TRYING TO TOGGLE QUEST MARKER FOR ", npc_name,
		" - NO NPC FOUND WITH THIS CHARACTER RESOURCE NAME")
