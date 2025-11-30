extends NPC

@export var follower_body: FollowerBody3D
@export var character_body: CharacterBody3D

func _enter_tree() -> void:
	Events.rowan_exterior_convo_finished.connect(_on_exterior_convo_finished)

func _on_exterior_convo_finished() -> void:
	follower_body.is_following_player = true
	follower_body.disable_movement = false
	character_body.process_mode = Node.PROCESS_MODE_DISABLED
