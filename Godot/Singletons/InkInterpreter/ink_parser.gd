extends Node

var json_dict : Dictionary #Dictionary from JSON file

var evaluation_mode : bool = false #Are we pushing/popping variables onto the stack?
var string_evaluation_mode : bool = false #Are we collecting choice text?
var line_string_eval_mode : bool = false #Are we collecting dialogue line text components?
var tag_evaluation_mode: bool = false

var evaluation_stack_items : Array = [] #Used for T/F calculations using player variables
var string_eval_stream : String = "" #Stores text for choices (text inside evaluation mode)
var line_in_construction : InkParseInfo

var last_speaker : String = "" #Inferred speaker
var tag: String = ""

const HASH_F : String = char(35) + "f"
func hash_f_only(dict : Dictionary) -> bool:
	if dict.has(HASH_F) and dict.keys().size() == 1:
		return true
	else:
		return false

##EVAL STACK FUNCTIONS
func pop() -> Variant:
	return evaluation_stack_items.pop_back()

func pop_of_type(target_type : Variant) -> Variant:
	var return_val : Variant = null
	var index_to_pop : int = -1;

	for item : Variant in evaluation_stack_items:
		index_to_pop += 1;
		if typeof(item) == target_type:
			break

	if index_to_pop > -1:
		return_val = evaluation_stack_items.pop_at(index_to_pop)
	
	return return_val

func push(item : Variant) -> void:
	evaluation_stack_items.push_back(item)

class InkParseInfo:
	var speaker : String
	var text_components : Array[String] = []
	var condition_stacks : Array[Array] = []
	var parent_container : InkContainer
	var path : String
	func _init(_parent_container : InkContainer, _path : String) -> void:
		InkParser.line_string_eval_mode = true
		speaker = ""
		parent_container = _parent_container
		path = _path
	
	func add_text_component(component : String) -> void:
		text_components.push_back(component)
	
	func add_condition_stack(stack : Array) -> void:
		print("Adding condition stack: ", stack)
		condition_stacks.push_back(stack)
	
	func export() -> void:
		#finished collecting LineInfo text components
		InkParser.line_string_eval_mode = false
		if speaker == "ChoiceInfo":
			#Automatically pushes itself to choices array
			#no redirect path required because it is only used as flavor text to the choices UI
			var choice_info_text : String = text_components[0]
			InkChoiceInfo.new(parent_container, path, choice_info_text, "")
		else:
			InkLineInfo.new(parent_container, path, speaker, text_components, condition_stacks)

func start_constructing_line(parent_container : InkContainer, path : String) -> bool:
	var new_line : bool = line_string_eval_mode == false
	if (new_line):
		line_in_construction = InkParseInfo.new(parent_container, path)

	return new_line

class InkParseContainer:
	var tree : InkTree
	var name : String
	var root : Array = []
	var path : String
	func _init(
		inktree : InkTree, 
		parent_container : InkContainer,
		container_name : String, 
		container_root : Array,
		_path : String = "",
		is_redirect : bool = false,
	) -> void:
		tree = inktree
		name = container_name
		root = container_root
		
		#var temp_containers : Array[InkParseContainer] = []
		# Find path
		if _path != "":
			path = _path
		elif parent_container:
			path = parent_container.path + "." + name
		else:
			path = "0"

		# Will automatically parent itself to parent_container if not null
		var new_ink_container : InkContainer = InkContainer.new(parent_container, name, path, [], is_redirect)
		
		#Find redirect table
		var last_element : Variant = root[root.size()-1]
		if last_element is Dictionary:
			var last_dict : Dictionary = last_element
			if !InkParser.hash_f_only(last_dict):
				#Then it is the redirect table
				for other_container_name : String in last_dict:
					if !(last_dict[other_container_name] is Array): continue
					var other_container : Array = last_dict[other_container_name]
					InkParseContainer.new( 
						null,
						new_ink_container, 
						other_container_name, 
						other_container,
						"",
						true,
					)

		# Assign contents
		var arr_index : int = 0
		for item : Variant in root:
			InkParser.classify_line(arr_index, new_ink_container, item)
			arr_index += 1

		# Add to InkTree if no parent container
		if !parent_container:
			tree.containers[name] = new_ink_container

func parse(file : JSON) -> InkTree:
	print("CONTAINER F PARSING -------------------------------")
	## Convert from JSON to dict
	var filepath : String = file.resource_path
	var json_as_text : String = FileAccess.get_file_as_string(filepath)
	json_dict = JSON.parse_string(json_as_text)

	var new_tree : InkTree = InkTree.new()

	##ROOT
	var root_container : Array = json_dict["root"][0]
	InkParseContainer.new(new_tree, null, "root", root_container)

	##OTHER CONTAINERS
	for other_container_name : String in json_dict["root"][2]:
		if other_container_name != HASH_F and json_dict["root"][2][other_container_name] is Array:
			var other_container : Array = json_dict["root"][2][other_container_name]
			InkParseContainer.new(new_tree, null, other_container_name, other_container)
	
	return new_tree

func _add_tag_to_line_info(line_info: InkLineInfo) -> void:
	var tokens := tag.split(" ", false)
	for token in tokens:
		if ":" in token:
			var kv := token.split(":", false, 1)
			var key := kv[0]
			var value := kv[1]
			line_info.metadata[key] = value
		else:
			line_info.tags.push_back(token)
			

func match_eval_cmd(new_container : InkContainer, path : String, next:Variant) -> bool:
	var was_command : bool = true
	match (next):
		"ev":
			evaluation_mode = true
			if (line_string_eval_mode):
				#lets InkLineInfo know you need to parse a condition stack to append onto the sentence
				line_in_construction.add_text_component("ev") 
		"/ev":
			evaluation_mode = false
			if (line_string_eval_mode):
				print("In string eval mode, pushing stack")
				line_in_construction.add_condition_stack(evaluation_stack_items.duplicate()) 
				evaluation_stack_items = []
		"#":
			tag_evaluation_mode = true
		"/#":
			assert(len(new_container.dialogue_lines) > 0, "Encountered tag, but no line to add tag to")
			var last_line: InkLineInfo = new_container.dialogue_lines[-1]
			assert(last_line != null, "Tried to add tag to a container")
			_add_tag_to_line_info(last_line)
			tag = ""
			tag_evaluation_mode = false
		"str":
			string_evaluation_mode = true
		"/str":
			string_evaluation_mode = false
			push(string_eval_stream)
			string_eval_stream = ""
		"end":
			InkLineInfo.new(
					new_container,
					path,
					"System",
					["end"],
				)
		"nop":
			InkLineInfo.new(
					new_container,
					path,
					"System",
					["nop"],
				)
		"out":
			var new_line : bool = start_constructing_line(new_container, path)
			if (new_line):
				print("Starting new line after the fact")
				#lets InkLineInfo know you need to parse a condition stack to append onto the sentence
				line_in_construction.add_text_component("ev") 

			push("out")
		_:
			was_command = false
	return was_command

func classify_line(arr_index : int, new_container : InkContainer, next : Variant) -> void:
	var path : String = new_container.path + "." + str(arr_index)
	new_container.total_nodes_inclusive += 1;
	if match_eval_cmd(new_container, path, next):
		return

	# NESTING
	if next is Array: #means there is a branch condition (either a choice or something condition-based)
		#print("Going into array: ", hierarchy)
		var arr : Array = next
		InkParseContainer.new(
			null, # no InkTree b/c we want to parent it to current container
			new_container, # this container
			path, # name (anonymous bc it is not in a dictionary)
			arr, # array root
			path,
		)
		return

	if next is String:
		var next_str : String = next
		if line_string_eval_mode && next_str == "\n":
			print("Exporting LineInfo")
			line_in_construction.export()

		elif next_str[0] == '^': #is string
			next_str = next_str.substr(1)

			if next_str.strip_edges().is_empty():
				return
			if string_evaluation_mode: #string eval mode takes precedence
				string_eval_stream = string_eval_stream + next_str
			elif tag_evaluation_mode:
				tag += next_str
			else:
				start_constructing_line(new_container, path)
				break_up_dialogue(next_str) #returns {"speaker":char_name, "text":dialogue_text}
			return

	if evaluation_mode:
		print("In evaluation mode")
		#We don't care about evaluating the stack right now, only storing it for later
		#Important because state variables will change at runtime
		#Store global variables
		if new_container.name == "global decl":
			print("STORING GLOBAL VARIABLES")
			if next is Dictionary:
				var next_dict : Dictionary = next
				if next_dict.has("VAR?"):
					var variable_name : String = next["VAR="]
					push(SaveSystem.get_key(variable_name))
				elif next_dict.has("VAR="):
					var variable_name : String = next["VAR="]
					print("Found variable named ", variable_name, " = ", SaveSystem.get_key(variable_name))
					# don't reassign if already assigned
					if !SaveSystem.key_exists(variable_name):
						var new_value : Variant = pop()
						print("Setting ", variable_name, " to ", new_value)
						SaveSystem.set_key(variable_name, new_value)
				elif string_evaluation_mode:
					if next_dict.has("->"):
						#get string value from redirect
						var redirect_name : String = next_dict["->"]
						var redirect_container : InkContainer = new_container.redirects[redirect_name]
						var first_line : InkLineInfo = redirect_container.dialogue_lines[0]
						string_eval_stream = string_eval_stream + first_line.text
			else:
				push(next)

		elif not string_evaluation_mode:
			if next is Dictionary:
				var next_dict : Dictionary = next
				if next_dict.has("^->") or next_dict.has("temp="):
					return
			print("Pushing to evaluation stack: ", next)
			push(next)
			'''
			Example:
				"ev",
				"str",
				"^If you're that worried...",
				"/str",
				"/ev",
			will result in:
				evaluation_stack_items = ["^If you're that worried..."]

			Example2:
				"ev",
				{
					"VAR?": "argue_SAM"
				},
				"/ev"
			will result in:
				evaluation_stack_items = [
				{
					"VAR?": "argue_SAM"
				}
				]
			'''
	elif not evaluation_mode: #not evaluation mode
		# CHOICES AND REDIRECTS
		if next is Dictionary:
			var next_dict : Dictionary = next
			if next_dict.has("*"):
				#Get choice text and any conditions that come with it (pushed on stack)
				var choice_text : String = pop_of_type(TYPE_STRING)
				#print("Choice text: ", string_eval_stream)
				#string_eval_stream = ""

				#Choice's redirect
				var redirect_location : String = next_dict["*"]
				#One-off choice?
				var once_only : bool = false

				#If 1 bit is set, store conditional statements on stack
				#these will be checked during runtime to decide whether to show the choice
				var eval_stack : Array = []
				#bits to check
				var flag_one : int = 1
				var flag_sixteen : int = 16

				var flag : int = next_dict["flg"]
				
				if flag&flag_one != 0: #check if 1 bit is set 
					#Means it is conditional text
					eval_stack = evaluation_stack_items.duplicate()
					evaluation_stack_items = []
				if flag&flag_sixteen != 0:
					print("One-off choice: ", choice_text)
					#Means it is a one-off choice
					once_only = true
				
				InkChoiceInfo.new(
					new_container, 
					path, 
					choice_text,
					redirect_location,
					[eval_stack],
					once_only,
				)
			elif next_dict.has("->"):
				var redirect : String = next_dict["->"]

				#conditional redirects
				var eval_stack : Array = []
				#var condition : bool = true
				if next_dict.has("c"):
					#condition = next_dict["c"]
					eval_stack = evaluation_stack_items.duplicate()
					evaluation_stack_items = []

				InkRedirect.new(
					new_container, 
					redirect,
					path,
					[eval_stack],
				)
			elif next_dict.has("VAR="):
				var eval_stack : Array = evaluation_stack_items.duplicate()
				print("Creating logic node for VAR= : ", eval_stack)
				eval_stack.push_back(next_dict)
				evaluation_stack_items = []
				InkLogicNode.new(
					new_container, 
					path,
					[eval_stack],
				)

func get_speaker_name(dialogue : String) -> Array:
	var char_name : String = ""
	var recording_name : bool = false
	var last_bracket_index : int = 0
	for n : int in range(dialogue.length()):
		var c : String = dialogue[n]
		if c == '[':
			recording_name = true
			continue
		elif c == ']':
			recording_name = false
			for i in range(n+1, dialogue.length()):
				if dialogue[i] != ' ': #set next index to first non-whitespace character
					last_bracket_index = i
					break
			#last_bracket_index = n+1
			break
		if recording_name:
			char_name = char_name + c

	if char_name.length() == 0:
		char_name = last_speaker
	elif char_name != "ChoiceInfo": #special case (choice flavor text)
		last_speaker = char_name

	return [char_name, last_bracket_index]

func break_up_dialogue(dialogue:String) -> void:
	#name of speaker should be between brackets; if not, infer it from last speaker
	#print("Parsing string into line: ", dialogue)
	var properties : Array = get_speaker_name(dialogue)
	var char_name : String = properties[0]
	var last_bracket_index : int = properties[1]
	
	var dialogue_text : String = dialogue.substr(last_bracket_index)
	
	line_in_construction.speaker = char_name
	line_in_construction.add_text_component(dialogue_text)

	#return InkLineInfo.new(parent_container, path, char_name, dialogue_text)
