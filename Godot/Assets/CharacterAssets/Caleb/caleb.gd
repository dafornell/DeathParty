extends NPC


@export var kitchen_door: SceneLoader


func _enter_tree() -> void:
	Events.caleb_entrance_convo_finished.connect(_on_entrance_convo_finished)


func _on_entrance_convo_finished() -> void:
	character_resource.character_location = Globals.SCENES.Basement
	SaveSystem.save_to_disk()

	if kitchen_door != null:
		animation_player.play("Skateboarding")
		# offset slightly from kitchen door so he doesnt skate through the girls standing in front of it
		# (if we could use the navigation region it would be cool but maybe its a lot of work to
		# implement if we're not having a lot of npcs moving like this)
		var target_position := Vector3(kitchen_door.global_position.x, global_position.y, kitchen_door.global_position.z + 1)
		look_at(target_position, Vector3.UP, true)
		var t: Tween = create_tween()
		t.tween_property(self, "global_position", target_position, 3.5)
		await t.finished

	fade_away_then_delete()
