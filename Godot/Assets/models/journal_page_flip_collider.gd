class_name PageFlipper extends ObjectViewerInteractable

@export var direction: int = 1
@export var bookflip_instance : BookFlip

var og_viewport : Viewport

var arrow: ThreeDGUI:
	get: 
		if direction < 0:
			return bookflip_instance.cur_arrows.left_arrow
		else:
			return bookflip_instance.cur_arrows.right_arrow

##INHERITED
func on_mouse_up() -> void:
	if Interact.grabbed_control: return
	if GuiSystem.inventory_showing: return
	bookflip_instance.flip_page(direction)

func enter_hover() -> void:
	if bookflip_instance.cur_subviewport == null: return
	og_viewport = get_viewport()
	arrow.enter_hover()
	#Interact.set_active_subviewport(bookflip_instance.cur_subviewport)
	
func exit_hover() -> void:
	if bookflip_instance.cur_subviewport == null: return
	#Interact.set_active_subviewport(og_viewport)
	arrow.exit_hover()
