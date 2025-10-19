class_name ClickableInventoryItem extends ObjectViewerInteractable

@export var mesh_root : Node3D
@export var hover_scale : float = 1.1
@export var hover_tween_duration : float = 0.1
@export var outline_shader : ShaderMaterial = preload("res://Assets/Shaders/OutlineShader/TestOutlineShader.tres")
@export var outline_thickness : float = 3

var hovered_amount : float = 0.0:
	set(value):
		hovered_amount = clampf(value, 0.0, 1.0)
		_interpolate_hover(hovered_amount)

var clicked_down : bool = false
var inventory_items_container : InventoryItemsContainer

var meshes : Array[MeshInstance3D] = []
var outline_material : ShaderMaterial = null
var cur_outline : float:
	get:
		assert(outline_material != null)
		return outline_material.get_shader_parameter("thickness")
	set(value):
		assert(outline_material != null)
		outline_material.set_shader_parameter("thickness", value)

var duplicated_mesh_container : Node3D = null
var initialized : bool = false

func _ready() -> void:
	_initialize()

# *not* _init, since we need the exported variables to be set first
func _initialize() -> void:
	if initialized: return
	initialized = true
	_find_meshes()
	_apply_outline_shader()
	_hide_outline()

func enter_hover() -> void:
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "hovered_amount", 1.0, hover_tween_duration)
	
func exit_hover() -> void:
	# this happens when we deparent the object
	# (note: enter hover should not happen if it is not in the scene tree)
	if not is_inside_tree():
		mesh_root.scale = Vector3.ONE
		return
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "hovered_amount", 0.0, hover_tween_duration)

func on_mouse_down() -> void:
	clicked_down = true

func on_mouse_up() -> void:
	if not clicked_down: return
	clicked_down = false
	show_item_details()

func show_item_details() -> void:
	# in case we call before _ready is called, make sure we get the duplicated_mesh_container
	_initialize()
	# duplicate again since it gets freed by the RotationObjectViewerInteractable
	InventoryUtils.show_node_item_details(item_resource, duplicated_mesh_container.duplicate() as Node3D)

func _find_meshes() -> void:
	if not meshes.is_empty():
		return
	var mesh_nodes := mesh_root.find_children("*", "MeshInstance3D", true, false)
	meshes.assign(mesh_nodes)

func _apply_outline_shader() -> void:
	duplicated_mesh_container = mesh_root.duplicate() as Node3D
	# we can share the same outline material across all meshes
	outline_material = outline_shader.duplicate()
	outline_material.set_shader_parameter("alpha", 1)
	outline_material.set_shader_parameter("thickness", 0)

	for mesh in meshes:
		var surface_material := mesh.get_active_material(0).duplicate() as StandardMaterial3D
		mesh.material_override = surface_material
		surface_material.next_pass = outline_material

func _show_outline() -> void:
	cur_outline = outline_thickness

func _hide_outline() -> void:
	cur_outline = 0

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		if duplicated_mesh_container != null:
			duplicated_mesh_container.free() # note: don't queue since no longer processing

func _interpolate_hover(t: float) -> void:
	mesh_root.scale = Vector3.ONE.lerp(Vector3.ONE * hover_scale, t)
	cur_outline = lerp(0.0, outline_thickness, t)
