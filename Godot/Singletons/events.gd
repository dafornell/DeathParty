extends Node


## emitted every time a character is printed to the main dialogue boxes
## (or when new text is loaded by skipping dialogue)
signal dialogue_box_text_changed

## toggle the quest marker on an NPC's interact popup
## - npc_name should match the spelling/capitalisation of the root node of
## the NPC scene AND the name in the character resource
signal toggle_quest_marker(npc_name: String, value: bool)

signal title_screen_settings_button_pressed


func _enter_tree() -> void:
	toggle_quest_marker.connect(_on_toggle_quest_marker)


func _on_toggle_quest_marker(npc_name: String, value: bool) -> void:
	var char_resource: CharacterResource = SaveSystem.get_character(npc_name)

	if char_resource != null:
		char_resource.quest_marker_enabled = value
	else:
		print("TRYING TO TOGGLE QUEST MARKER FOR ", npc_name,
		" - NO NPC FOUND WITH THIS CHARACTER RESOURCE NAME")
