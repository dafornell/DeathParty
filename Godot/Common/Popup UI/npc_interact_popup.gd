@tool
extends Node3D


@export var quest_marker_enabled := false:
	set(value):
		quest_marker_enabled = value

		# i think export vars get set on enter_tree so we have to check this
		# isnt null in case it tries to hide this before it exists and causes
		# an error ↓

		# TODO: maybe make this script just send a signal down and have the
		#		quest marker just show/hide itself to avoid any weird stuff
		#		like this
		#				- jack
		if quest_marker == null:
			return

		if quest_marker_enabled:
			quest_marker.show()
			if not Engine.is_editor_hint():
				show()
		else:
			quest_marker.hide()
			if not Engine.is_editor_hint():
				hide()



@export var x_offset: float = -1.15
@export var y_offset: float = 2

@onready var parent_npc: NPC = get_parent()
@onready var quest_marker: Sprite3D = %QuestMarker


func _enter_tree() -> void:
	Events.toggle_quest_marker.connect(_on_toggle_quest_marker)

	match_quest_marker_var_to_value_in_resource()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	# since rotating the npc will affect the global position of this popup,
	# we reset it every frame based on the current global pos of the npc to
	# keep its position consistent
	if parent_npc:
		global_position = parent_npc.global_position + Vector3(x_offset, y_offset, 0)


# make the popup always show (regardless of player distance to npc) if the
# quest marker is enabled by forcing it back to visible if it gets hidden
func _on_visibility_changed() -> void:
	if visible:
		return

	if quest_marker_enabled:
		show()


func _on_toggle_quest_marker(npc_name: String, value: bool) -> void:
	if npc_name != parent_npc.name:
		return

	quest_marker_enabled = value


func match_quest_marker_var_to_value_in_resource() -> void:
	# NOTE: this didnt work until i added this line to wait a frame - i think
	#		maybe values in resources don't get properly initialised
	#		on the first ready frame or whatever, so it'll always read this
	#		var as false if you don't wait first 🤓
	#				- jack
	await get_tree().process_frame

	var char_resource: CharacterResource = parent_npc.character_resource

	if char_resource:
		quest_marker_enabled = char_resource.quest_marker_enabled
