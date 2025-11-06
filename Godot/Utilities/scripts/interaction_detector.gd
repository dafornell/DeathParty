## Emits a signal when the player is within the area and presses interact
## To use, make an InteractionDetector instance a child of the node that the user interacts with
## then manually create a collision object as a child of the created instance
class_name InteractionDetector extends Area3D

@export var collision_shape : CollisionShape3D

signal player_interacted()
signal player_in_range(tf : bool)

var player_currently_in_range : bool = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_currently_in_range:
		player_interacted.emit()


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		# NOTE: sorry for this weird code - this is basically to stop it from
		# 		adding npcs that you cant talk to to the priority list and
		# 		having them block others ('grandparent' because the
		# 		interactiondetector is a child of the characterbody, not the
		# 		npc itself (i think))
		var grandparent = get_parent().get_parent()

		if grandparent is NPC and grandparent.character_resource != null:
			if grandparent.character_resource.has_chats():
				InteractablePriority.add_interactable(self)

		# and if its not an npc, just add it to the list
		else:
				InteractablePriority.add_interactable(self)


func _on_body_exited(body : Node3D) -> void:
	if body.is_in_group("player"):
		#Add interaction to the priority
		InteractablePriority.remove_interactable(self)
		pass


#Enables the Detector
func enable() -> void:
	player_currently_in_range = true
	player_in_range.emit(true)


func disable() -> void:
	player_currently_in_range = false
	player_in_range.emit(false)
