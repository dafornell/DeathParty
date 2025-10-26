class_name InventoryItemResource extends DefaultResource

@export var description : String
@export var model : PackedScene
# Note: these two properties are left in case we want to use them later

## @deprecated Change the scale in the model itself
@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_NO_EDITOR) var inventory_scale : float = 1.0
## @deprecated Change inventory item slot in bookflip_collisionbody.tscn
@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_NO_EDITOR) var inventory_position : Vector2 = Vector2.ZERO

@export var amount_owned : int = 0
@export var dialogue_on_first_view : JSON
var viewed : bool = false
