class_name InkNode extends RefCounted

# Initialization
var parent_container : InkContainer
var path : String
var all_evaluation_stacks : Array[Array]

# SaveSystem variables
var SAVE_SYSTEM_UID : String = ""
var parent_filepath : String
var save_variables : Dictionary[String, Variant]

# At runtime
const ALL_OPERATORS : Array[String] = ["+", "-", "/", "*", "%", "==", ">", "<", ">=", "<=", "!=", "!", "&&", "||", "MIN", "MAX"]
var runtime_stack : Array = []

##EVAL STACK FUNCTIONS
func pop() -> Variant:
	return runtime_stack.pop_back()

func push(item : Variant) -> void:
	runtime_stack.push_back(item)

func _init(
	_parent_filepath : String,
	_container: InkContainer, 
	_path : String, 
	_all_evaluation_stacks: Array[Array], 
) -> void:
	parent_container = _container
	path = _path
	all_evaluation_stacks = _all_evaluation_stacks

	parent_filepath = _parent_filepath
	if parent_filepath != "":
		parent_filepath = parent_filepath.substr(21)
		SAVE_SYSTEM_UID = parent_filepath + "/" + path

func validate_save_uid() -> void:
	if parent_filepath != "":
		SAVE_SYSTEM_UID = parent_filepath + "/" + path
	assert(SAVE_SYSTEM_UID != "", "InkNode " + path + " is not connected to a .json filepath, so you cannot access its save data.")

func load_save_variable(key : String, default_value : Variant) -> void:
	validate_save_uid()
	var KEY_ID : String = SAVE_SYSTEM_UID + "-" + key
	if !SaveSystem.key_exists(KEY_ID):
		SaveSystem.set_key(KEY_ID, 0)
		save_variables[key] = default_value
	else:
		save_variables[key] = SaveSystem.get_key(KEY_ID)

func set_save_variable(key : String, value : Variant) -> void:
	validate_save_uid()
	var KEY_ID : String = SAVE_SYSTEM_UID + "-" + key
	save_variables[key] = value
	SaveSystem.set_key(KEY_ID, value)

func get_save_variable(key : String) -> Variant:
	validate_save_uid()
	var KEY_ID : String = SAVE_SYSTEM_UID + "-" + key
	return SaveSystem.get_key(KEY_ID)

func tostring() -> String:
	var eval_stack_str : String = "Evaluation stack: \n"
	for item : Variant in runtime_stack:
		eval_stack_str = eval_stack_str + "Evaluation stack item: " + str(item) + "\n"
	return eval_stack_str

## EVALUATION STACK TO DETERMINE IF VISIBLE
func stack_operations(stack_index : int) -> void:
	var stack : Array[Variant] = all_evaluation_stacks[stack_index]
	print("STACK INDEX: ", stack_index, " out of ", all_evaluation_stacks.size())
	for item : Variant in stack:
		print("Eval stack item: ", item)
		if item is String and ALL_OPERATORS.has(item):
			print("Logical operation")
			var item_str : String = item
			logical_operation(item_str)
		elif item is Dictionary:
			var item_dict : Dictionary = item
			if item_dict.has("VAR?"):
				var variable_name : String = item_dict["VAR?"]
				print("Push variable: ", variable_name, " ", SaveSystem.get_key(variable_name), " ", SaveSystem.get_key(variable_name) is bool)
				push(SaveSystem.get_key(variable_name))
			elif item_dict.has("VAR="):
				print("Pop variable")
				var variable_name : String = item_dict["VAR="]
				SaveSystem.set_key(variable_name, pop())
			# elif item_dict.has("CNT?"):
			# 	push(SaveSystem.get_key(variable_name))
		elif item is String:
			match(item):
				"du":
					#duplicate
					push(item)
				"visit":
					if self is InkContainer:
						var container : InkContainer = self
						push(container.visits)
					else:
						push(self.parent_container.visits)
				"out":
					if self is InkLineInfo:
						var line : InkLineInfo = self
						var addtl_text:String = pop();
						line.runtime_text = line.runtime_text + addtl_text
				_:
					push(item) # to be popped off later
		else:
			push(item)

func is_visible() -> bool:
	if all_evaluation_stacks.is_empty():
		return true
	
	stack_operations(0);
	
	if runtime_stack.size() == 0:
		return true

	var result : Variant = pop()
	print("Result: ", result)

	if not (result is bool):
		result = true
	
	runtime_stack = []
	return result

func logical_operation(current_operator : String) -> Variant:
	print("Logical operation. Current stack: ", runtime_stack)
	var arg1 : Variant = pop()
	var arg2 : Variant = null
	if current_operator != "!": # ! is a single argument function
		arg2 = pop()
	return operate(current_operator, arg2, arg1)

func operate(op : String, arg1 : Variant, arg2 : Variant) -> Variant:
	if arg2 != null:
		if typeof(arg1) != typeof(arg2):
			var number_mismatch : bool = (arg1 is int || arg1 is float) && (arg2 is int || arg2 is float)
			if !number_mismatch:
				#puts them both in true or false terms
				arg1 = !!arg1
				arg2 = !!arg2
	#print("OPERATING: ", arg1, op, arg2)
	var result : Variant#can be bool or number
	match (op):
		"+":
			result = arg1+arg2
		"-":
			result = arg1-arg2
		"/":
			result = arg1/arg2
		"*":
			result = arg1*arg2
		"%":
			result = arg1%arg2
		"==":
			result = arg1==arg2
		">":
			result = arg1>arg2
		"<":
			result = arg1<arg2
		">=":
			result = arg1>=arg2
		"<=":
			result = arg1<=arg2
		"!=":
			result = arg1!=arg2
		"!":
			result = !arg1
		"&&":
			result = arg1&&arg2
		"||":
			result = arg1||arg2
		"MIN":
			result = min(arg1,arg2)
		"MAX":
			result = max(arg1,arg2)
			
	push(result)
	print("operation result: ", arg1, op, arg2, "=", result)
	return result
