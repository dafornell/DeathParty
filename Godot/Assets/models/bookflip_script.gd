class_name BookFlip extends Node3D

@onready var page_flip_sound : FmodEventEmitter2D = %PageFlipSound

@export var animation_player : AnimationPlayer

@export var page1 : MeshInstance3D
@export var page2 : MeshInstance3D

@export var page1_subviewport : SubViewport
@export var page2_subviewport : SubViewport

@export var container_left: Control
@export var container_right: Control

@export var arrows_left: Arrows
@export var arrows_right: Arrows

@export var viewport_texture1 : ViewportTexture
@export var viewport_texture2 : ViewportTexture

var page1_mat : ShaderMaterial
var page2_mat : ShaderMaterial

@export var journal_textures : Array[PackedScene]
var journal_textures_size : int 

var cur_page_index : int = 0
var flipping : bool = false

@export var tabs_node : Node
var tabs : Array[JournalTab]

var cur_tab : Node
var old_tab : Node

var tab_handler : JournalTabHandler

var cur_subviewport : Viewport  #referenced in other classes
var cur_arrows: Arrows

func _ready() -> void:
	page1_subviewport.size = Vector2i(1920, 1080)
	page2_subviewport.size = Vector2i(1920, 1080)
	
	for tab in tabs_node.get_children():
		if tab is JournalTab:
			tabs.push_back(tab)
	
	tab_handler = JournalTabHandler.new(self, tabs)
	
	cur_tab = tab_handler.get_tab(0)
	old_tab = tab_handler.get_tab(0)
	
	page1_mat = page1.material_overlay
	page2_mat = page2.material_overlay

	page1_mat.set_shader_parameter("multiplier", 1)
	page2_mat.set_shader_parameter("multiplier", 1)
	
	journal_textures_size = journal_textures.size()
	animation_player.animation_finished.connect(_on_anim_finished)
	animation_player.play("Idle")
	
	#set left page texture to first page
	set_page(1, cur_page_index)

func flip_to_page(new_page_index : int) -> void:
	if flipping:
		return
	var old_page_index := cur_page_index
	
	if new_page_index == cur_page_index or new_page_index < 0 or new_page_index >= journal_textures_size:
		return
	
	var delta := new_page_index - cur_page_index
	cur_page_index = new_page_index

	flipping = true
	
	if delta < 0:
		set_page(2, old_page_index)
		set_page(1, cur_page_index)
		animation_player.play("Flip Back")
	else:
		set_page(1, old_page_index)
		set_page(2, cur_page_index)
		animation_player.play("Flip Front")
	
	page_flip_sound.play()
	tab_handler.flip_page(cur_page_index)

func set_page(side_of_page : int, index : int) -> void:
	var page_prefab : PackedScene = journal_textures[index]
	var page_mat : ShaderMaterial = page1_mat
	var page_subviewport : Viewport = page1_subviewport
	var container: Control = container_right
	var viewport_texture : ViewportTexture = viewport_texture1
	var arrows : Arrows = arrows_right
	if side_of_page == 2:
		page_mat = page2_mat
		page_subviewport = page2_subviewport
		viewport_texture = viewport_texture2
		container = container_left
		arrows = arrows_left
	#clear children of subviewport if any
	for child in container.get_children():
		container.remove_child(child)
		child.queue_free()
	
	page_mat.set_shader_parameter("albedo_texture", viewport_texture)
	viewport_texture.viewport_path = page_subviewport.get_path()
	container.add_child(page_prefab.instantiate())
	
	arrows.left_arrow_visible = (index - 1) >= 0
	arrows.right_arrow_visible = (index + 1) < journal_textures.size()
	
	cur_subviewport = page_subviewport
	cur_arrows = arrows

func can_flip_page(direction: int) -> bool:
	assert(direction == -1 or direction == 1, "Direction must be -1 (backward) or 1 (forward)")
	var new_page_index: int = cur_page_index + direction
	return not (new_page_index < 0 or new_page_index >= journal_textures_size)

func flip_page(delta: int) -> void:
	flip_to_page(cur_page_index + delta)

func _on_anim_finished(anim_name: StringName) -> void:
	if anim_name == "Flip Back" or anim_name == "Flip Front":
		set_page(1, cur_page_index)
		flipping = false
		animation_player.play("Idle")
