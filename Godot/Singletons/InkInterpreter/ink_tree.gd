class_name InkTree extends RefCounted

var filepath : String
var containers : Dictionary[String, InkContainer] = {}

func _init(_filepath : String) -> void:
    filepath = _filepath