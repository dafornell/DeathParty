class_name ItemInfoContainer extends InfoContainerGUI

@export var description_label : RichTextLabel

func set_text(description : String) -> void:
	description_label.text = description
