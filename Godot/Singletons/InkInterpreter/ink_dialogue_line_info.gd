class_name InkLineInfo extends RefCounted

var speaker : String
var text : String
var metadata : Dictionary

func _init(_speaker : String, _text: String) -> void:
	speaker = _speaker
	text = _text