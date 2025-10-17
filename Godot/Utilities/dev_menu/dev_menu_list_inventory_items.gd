extends Node

func _on_pressed() -> void:
    for item: String in SaveSystem.active_save_file.inventory_items.keys():
        var res := SaveSystem.get_inventory_item(item)
        print(item + ": " + str(res.amount_owned))
