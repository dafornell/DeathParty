class_name BarkContainer extends Interactable

@export_file("*.json") var conversation_json: String
@export var bark_popups: Array[BarkPopup]
@export var bark_interact: Sprite3D

var activated_bark: bool = false
var conversations_count: int
var speakers_count: int
## Contains an array of each conversation. Each conversation is itself an array
## containing dictionaries holding speaker and bark information.
## [codeblock]
##	[
##	[
##		{
##			"speaker": 0
##			"text": "This is the first dialogue"
##		},
##		{
##			"speaker": 1
##			"text": "This is the reply"
##		}
##	],
##	[
##		{
##			"speaker": 0
##			"text": "This is the second conversation"
##		}
##	]
## ]
## [/codeblock]
var conversations: Array # Should hold Array[Array[Dictionary]], but nested containers not supported


func _ready() -> void:
	super()
	if bark_interact:
		bark_interact.visible = false
	var conversation_string : String = FileAccess.get_file_as_string(conversation_json)
	var json: JSON = JSON.new()
	var try_parse: Error = json.parse(conversation_string)
	if try_parse == OK:
		conversations_count = json.data["number_of_conversations"]
		speakers_count = json.data["number_of_speakers"]
		conversations = json.data["conversations"]
	else:
		assert(false, "Error parsing bark conversation!")


func toggle_bark_popup(is_on: bool) -> void:
	if bark_interact and not activated_bark:
		bark_interact.visible = is_on


func on_in_range(in_range: bool) -> void:
	super(in_range)
	toggle_bark_popup(in_range)


func on_interact() -> void:
	super()
	toggle_bark_popup(false)
	if not activated_bark:
		activate_bark()


func activate_bark() -> void:
	activated_bark = true
	play_conversation( randi_range(0, conversations_count-1) ) # play a random conversation



func play_conversation(convo_index: int) -> void:
	for bark: Dictionary in conversations[convo_index]:
		var speaker_index: int = bark["speaker"]
		var speaker: BarkPopup = bark_popups[speaker_index]
		var dialogue: String = bark["text"]
		
		speaker.animate_bark_text(dialogue)
		await speaker.finished_bark
	activated_bark = false
