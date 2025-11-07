@tool
class_name NPCInteractPopup extends Node3D
## this script handles the logic for the quest marker as well as the pop-up
## because the marker was previously part of the pop-up - the marker could have
## its own script but most of the old logic didn't change with the new setup
## so i think its ok to leave it like this for now
##		- jack

@export var x_offset: float = -1.15
@export var y_offset: float = 2

@onready var parent_npc: NPC = get_parent()
@onready var quest_marker: Sprite3D = %QuestMarker

var quest_marker_enabled := false:
	set(value):
		quest_marker_enabled = value

		# i think export vars get set on enter_tree so we have to check this
		# isnt null in case it tries to hide this before it exists and causes
		# an error ↓

		# TODO: maybe make this script just send a signal and have the
		#		quest marker just show/hide itself to avoid any weird stuff
		#		like this
		#				- jack
		if quest_marker == null:
			return

		if quest_marker_enabled:
			quest_marker.show()

			var tween: Tween = create_tween()
			tween.set_loops()
			tween.tween_property(quest_marker, "transparency", 1.0, quest_marker_tween_duration)
			tween.tween_property(quest_marker, "transparency", 0.0, quest_marker_tween_duration)

		else:
			quest_marker.hide()

var quest_marker_tween_duration := 1.0


func _enter_tree() -> void:
	match_quest_marker_var_to_value_in_resource()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	# since rotating the npc will affect the global position of this popup,
	# we reset it every frame based on the current global pos of the npc to
	# keep its position consistent
	if parent_npc:
		global_position = parent_npc.global_position + Vector3(x_offset, y_offset, 0)

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
