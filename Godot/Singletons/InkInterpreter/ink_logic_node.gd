class_name InkLogicNode extends InkNode

#just meant for executing background logic (such as assigning new values to variables)

func _init( 
	_parent_filepath : String,
	_parent_container: InkContainer,
	_path : String,
	_condition_stacks: Array[Array] = [[]], 
) -> void:
	super(_parent_filepath, _parent_container, _path, _condition_stacks)
	if parent_container:
		parent_container.dialogue_lines.push_back(self)

func tostring() -> String:
	var eval_stack : String = super()
	return "Logic execute: " + eval_stack

func execute() -> void:
	print("Executing logic node: ", all_evaluation_stacks)
	stack_operations(0)
