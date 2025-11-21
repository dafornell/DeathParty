class_name InkLineInfo extends InkNode

var speaker : String
var text_components : Array[String]
var runtime_text : String = "" #built at runtime (sometimes text has inline variables)

var tags: Array[String] = []
var metadata: Dictionary[String, String] = {}

func _init( 
	_parent_container: InkContainer,
	_path : String,
	_speaker : String,
	_text_components : Array[String], #of strings
	_condition_stacks: Array[Array] = [[]], 
) -> void:
	super(_parent_container, _path, _condition_stacks)
	speaker = _speaker
	text_components = _text_components
	if parent_container:
		parent_container.dialogue_lines.push_back(self)

func update() -> void:
	runtime_text = ""
	var stack_index : int = 0
	for item : String in text_components:
		if item == "ev": #indicates that you need to evaluate a condition stack
			self.stack_operations(stack_index)
			stack_index+=1
		else:
			runtime_text = runtime_text + item

var text : String:
	get:
		return runtime_text

func tostring() -> String:
	var eval_stack : String = super()
	return "Line: " + speaker + " | Text: " + text + " " + eval_stack
