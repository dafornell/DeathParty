class_name Interactable extends Node3D

@export var primary_mesh: MeshInstance3D
@export var use_first_mesh: bool = true
@export var surface_index: int = 0
@export var outline_thickness: float = 3
@export var outline_depth_offset : float = 0.00005

@export var talking_object_resource: TalkingObjectResource

#@export var outline_shader : ShaderMaterial = preload("res://Assets/Shaders/OutlineShader.tres")
var outline_shader: ShaderMaterial = preload("res://Assets/Shaders/OutlineShader/TestOutlineShader.tres")
var interaction_detector_file: PackedScene = preload("res://Entities/interaction_detector.tscn")
@export var interaction_detector: InteractionDetector

@export var enabled: bool = true:
	set(value):
		enabled = value
		# call on_in_range if the player is already standing in the interactable
		# area when the interactable gets enabled (since otherwise it wouldnt
		# get an on_entered signal since the player's already in there)
		if enabled and interaction_detector:
			print("Checking if enabled: ", interaction_detector)
			var overlapping_bodies: Array = interaction_detector.get_overlapping_bodies()
			for body: PhysicsBody3D in overlapping_bodies:
				if body == Globals.player:
					on_in_range(true)

## If not null, this item will despawn whenever the player has this item
@export var inventory_item: InventoryItemResource

var popup: Node3D
var surface_material: StandardMaterial3D = null


func _ready() -> void:
	if inventory_item:
		_despawn_if_has_item()
		SaveSystem.inventory_changed.connect(_on_inventory_changed)
	
	if not interaction_detector:
		interaction_detector = get_node_or_null("InteractionDetector")
	if interaction_detector == null:
		interaction_detector = interaction_detector_file.instantiate()
		var char_body: CharacterBody3D = get_node_or_null("CharacterBody3D")
		var follower_body: FollowerBody3D = get_node_or_null("FollowerBody3D")
		if char_body:
			char_body.add_child(interaction_detector)
		elif follower_body:
			follower_body.add_child(interaction_detector)
		else:
			add_child(interaction_detector)
	interaction_detector.player_interacted.connect(on_interact)
	interaction_detector.player_in_range.connect(on_in_range)

	# Get the popup that will be used:
	popup = get_node_or_null("Popup")

	#print("Loading ", name, ": ", primary_mesh, " ", use_first_mesh)
	if primary_mesh:
		create_outline()
	elif use_first_mesh:
		primary_mesh = Utils.find_first_child_of_class(self, MeshInstance3D)
		create_outline()
	if popup:
		popup.visible = false


func create_outline() -> void:
	#print("Creating outline")
	if primary_mesh == null: return
	surface_material = primary_mesh.get_active_material(surface_index)
	var new_shader: ShaderMaterial = outline_shader.duplicate()
	new_shader.set_shader_parameter("alpha", 0)
	surface_material.next_pass = new_shader


func toggle_popup(on: bool) -> void:
	if popup:
		popup.visible = on
	if surface_material:
		var value: float
		if on:
			value = 1.0
		else:
			value = 0.0
		var shader: ShaderMaterial = surface_material.next_pass

		# set the thickness here just in case it's modified in the editor
		shader.set_shader_parameter("thickness", outline_thickness)
		shader.set_shader_parameter("depth_offset", outline_depth_offset)
		shader.set_shader_parameter("alpha", value)
	if talking_object_resource:
		talking_object_resource = SaveSystem.get_talking_object(talking_object_resource.name)


##OVERRIDE THESE METHODS (but call super() at the beginning)
# NOTE: you might need to also add the enabled check at the beginning
#		of your overriding method 
func on_interact() -> void:
	if !enabled :return
	toggle_popup(false)
	Events.interacted.emit(self)
	if talking_object_resource:
		talking_object_resource.start_chat()

	# rotate player model towards interactable (commented out for now because
	# it rotates towards NPCs when we 'interact' with them even if they don't
	# actually have chats which looks weird)
	#var player_model: Node3D = Globals.player.get_node_or_null("PlayerModel")
#
	#if player_model != null:
		#player_model.look_at(global_position, Vector3.UP, true)
		#player_model.rotation = Vector3(0, player_model.rotation.y, 0)


func on_in_range(in_range: bool) -> void:
	if !enabled: return
	toggle_popup(in_range)
	if in_range:
		Events.interaction_area_entered.emit(self)
	else:
		Events.interaction_area_exited.emit(self)


func _on_inventory_changed(_addremove : String, item : InventoryItemResource) -> void:
	if !inventory_item: return
	if item.name != inventory_item.name: return
	_despawn_if_has_item(item)


func _despawn_if_has_item(item : InventoryItemResource = null) -> bool:
	if item == null:
		if inventory_item == null: return false
		item = SaveSystem.item_exists(inventory_item.name)
	# NOTE: if we add any items the player can have multiple of, i think we'll
	#		have to rework this, but its good for now :D
	#				- jack
	if item and item.amount_owned > 0:
		queue_free()
		return true
	return false
