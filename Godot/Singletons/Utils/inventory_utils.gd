extends Node

var object_viewer : ObjectViewer
const dialogue_box : DialogueBoxResource = preload("res://Assets/Resources/DialogueBoxResources/main_dialogue_box_properties.tres")
const OBJECT_VIEWER_ROTATABLE_SCENE : PackedScene = preload("res://Common/Object Viewer/object_viewer_rotatable.tscn")

func _ready() -> void:
	var main : Node3D = get_tree().root.get_node_or_null("Main")
	if main == null: return
	
	object_viewer = main.get_node("ObjectViewerCanvasLayer/ObjectViewer")

## @deprecated Make sure your scene derives from inventory_item_base.tscn and directly instantiate it
func create_clickable_item(
	item_resource : InventoryItemResource, 
	item : Node3D = null
	) -> ObjectViewerInteractable:
	if item == null:
		item = item_resource.model.instantiate()
	var static_body : ObjectViewerInteractable
	if item.name.substr(0,8) == "polaroid":
		static_body = DragDropPolaroid.new()
		static_body.item_resource = item_resource
		#static_body.main_page = main_page
	else:
		var inventory_item_interactable := ClickableInventoryItem.new()
		inventory_item_interactable.item_resource = item_resource
		static_body = inventory_item_interactable
	
	var mesh_children : Array[Node] = Utils.get_descendants(item, [MeshInstance3D], false)
	for mesh : MeshInstance3D in mesh_children:
		fix_materials(mesh)
	
	print("STATIC BODY SCALE: ", static_body.scale)
	static_body.name = item_resource.name
	var collision_shape : CollisionShape3D = CollisionShape3D.new()
	collision_shape.name = "CollisionShape3D"
	collision_shape.shape = BoxShape3D.new()
	collision_shape.shape.extents = Vector3(.2,.5,.2)
	
	#static_body.global_position = item.global_position
	static_body.add_child(collision_shape)
	static_body.add_child(item)
	
	item.position = Vector3.ZERO
	item.rotate(Vector3(1,0,0), deg_to_rad(90))
	item.rotate(Vector3(0,1,0), deg_to_rad(180))
	
	return static_body

#When duplicating, materials get messed up
func fix_materials(mesh : MeshInstance3D) -> void:
	if not mesh.mesh: return
	if mesh.material_overlay: return
	# Fix materials from the original mesh's surfaces
	for i in range(mesh.mesh.get_surface_count()):
		var material : Material= mesh.get_active_material(i)
		if material is BaseMaterial3D:
			var base_material : BaseMaterial3D = material
			base_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA

## Calls show_node_item_details with the model from item_resource
func show_inventory_item_details(item_resource : InventoryItemResource) -> void:
	if item_resource.model == null:
		push_error("Item resource model is null: " + item_resource.name)
		return
	var clickable_inventory_item := item_resource.model.instantiate() as ClickableInventoryItem
	if clickable_inventory_item == null:
		push_error("Item resource model is null or is not a ClickableInventoryItem: " + item_resource.name)
		return
	clickable_inventory_item.item_resource = item_resource
	assert(clickable_inventory_item is ClickableInventoryItem)
	GuiSystem.hide_journal(true)
	clickable_inventory_item.show_item_details()


## Shows the item details in item_resource along with
## the node passed in to rotate.
func show_node_item_details(
	item_resource : InventoryItemResource,
	node : Node3D
) -> void:
	var object_viewer_rotatable := OBJECT_VIEWER_ROTATABLE_SCENE.instantiate() as ObjectViewerRotatable
	object_viewer_rotatable.add_item_to_viewer(node)

	object_viewer.set_preexisting_item(object_viewer_rotatable)
	object_viewer.view_item_info(item_resource)
	if item_resource.viewed == false:
		item_resource.viewed = true
		if item_resource.dialogue_on_first_view != null:
			await object_viewer.get_tree().process_frame
			#DialogueSystem.begin_dialogue(item_resource.dialogue_on_first_view)

	object_viewer.reset_zoom()
