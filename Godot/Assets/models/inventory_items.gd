class_name InventoryItemsContainer extends Node3D

@export var bookflip_instance : BookFlip
# the children of this node are the slots to place items in
@export var item_slot_parent : Node3D

var main_page : MeshInstance3D

var player_inventory : Dictionary[String, InventoryItemResource]

var slot_map : Dictionary[String, Node3D] = {}
var extra_slots : Array[Node3D] = []
var item_instances : Array[ObjectViewerInteractable]

var items_showing : bool = false


func _init() -> void:
	SaveSystem.inventory_changed.connect(on_inventory_change)


func _ready() -> void:
	load_items()
	hide_items()
	preprocess_slots()
	if bookflip_instance:
		main_page = bookflip_instance.page1

	show_items()


func preprocess_slots() -> void:
	slot_map.clear()
	extra_slots.clear()
	for slot: Node in item_slot_parent.get_children():
		var item_slot : InventoryItemSlot = slot as InventoryItemSlot
		assert(item_slot != null, "Child of item_slot_parent is not an InventoryItemSlot!")
		if item_slot.item_resource != null:
			slot_map[item_slot.item_resource.name] = item_slot
		else:
			extra_slots.append(item_slot)

func on_inventory_change(action:String, item:InventoryItemResource) -> void:
	var itemCount : int = item.amount_owned
	if action == "remove" and itemCount == 0:
		delete_item(item.name)
		return
	elif action == "add" and itemCount == 1:
		new_item(item.name)
		refresh_items()
	
func new_item(item_name:String) -> void:
	var item_resource : InventoryItemResource = SaveSystem.get_inventory_item(item_name)
	if item_resource.model == null: return
	# var static_body : ObjectViewerInteractable = InventoryUtils.create_clickable_item(item_resource)
	var interactable : ObjectViewerInteractable = item_resource.model.instantiate() as ObjectViewerInteractable
	assert(interactable != null, "Item model is not an ObjectViewerInteractable: " + item_name)
	interactable.item_resource = item_resource

	var clickable_inventory_item := interactable as ClickableInventoryItem
	if clickable_inventory_item != null:
		clickable_inventory_item.inventory_items_container = self
	
	item_instances.push_back(interactable)
	#print("Static body name: ", static_body.name)

func delete_item(item_name:String) -> void:
	var index : int = 0
	for item in item_instances:
		if item.name == item_name:
			self.remove_child(item)
			item.queue_free()
			item_instances.remove_at(index)
			break
		index += 1

func load_items() -> void:
	#print("Loading items!")
	player_inventory = SaveSystem.get_inventory()
	for item_name : String in player_inventory:
		var item : InventoryItemResource = player_inventory[item_name]
		if item.amount_owned == 0: continue
		new_item(item_name)
	#show_items()

func show_items() -> void:
	items_showing = true
	var extra_slot_idx := 0
	for item in item_instances:
		if item.item_resource.name in slot_map:
			var fixed_slot := slot_map[item.item_resource.name]
			fixed_slot.add_child(item)
		else:
			if extra_slot_idx >= len(extra_slots):
				print("Not enough item slots to show all items!")
				break
			var extra_slot := extra_slots[extra_slot_idx]
			extra_slot.add_child(item)
			extra_slot_idx += 1

func hide_items() -> void:
	items_showing = false
	for slot in item_slot_parent.get_children():
		for child in slot.get_children():
			slot.remove_child(child)
		
func refresh_items() -> void:
	var old_items_showing : bool = items_showing
	hide_items()
	if old_items_showing:
		show_items()
