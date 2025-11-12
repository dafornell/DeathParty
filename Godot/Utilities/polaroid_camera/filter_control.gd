class_name FilterControl extends Node2D

@export var left_button: Button
@export var right_button: Button
@export var filter_base_button :Button
@export var lens: TextureRect
@export var ViewFinder: TextureRect
@export var filter_letter: TextureRect 
@export var f_image:TextureRect

@onready var blue_filter: Image = Image.load_from_file("res://Assets/PNGAssets/blue_lens.png")
@onready var red_filter: Image = Image.load_from_file("res://Assets/PNGAssets/red_lens.png")
@onready var green_filter: Image = Image.load_from_file("res://Assets/PNGAssets/green_lens.png")

@onready var N: Image = Image.load_from_file("res://Assets/PNGAssets/N.png")
@onready var R: Image = Image.load_from_file("res://Assets/PNGAssets/R.png")
@onready var G: Image = Image.load_from_file("res://Assets/PNGAssets/G.png")
@onready var B: Image = Image.load_from_file("res://Assets/PNGAssets/B.png")

var lens_color=""
var correct_color=""
#reassign filter image
func filter_image(color:String):
	if color=="R":
		correct_color="red"
	if color=="G":
		correct_color="green"
	if color=="B":
		correct_color="blue"
	
	
func _on_left_button_pressed() -> void:
	left_button.disabled=true
	#turns wheel 90 degrees to the left from its current orientation	
	var CurrentRotation=$filter_base.rotation_degrees
	CurrentRotation-= 90
	var tween=create_tween()
	tween.tween_property($filter_base, "rotation",  deg_to_rad(CurrentRotation), .3)
	#prevents player from turning the wheel mid-rotation since turning before tween is finsihed will cause it to turn 90 degrees from the wrong orientation 
	#and the colors on the wheels won't be in their intended positions (top, bottom, left, right)
	await tween.finished
	left_button.disabled=false
	
#function for when player turns the filter wheel right 
func _on_right_button_pressed() -> void:
	right_button.disabled=true
	#turns wheel 90 degrees to the right from its current orientation 
	var CurrentRotation=$filter_base.rotation_degrees
	CurrentRotation+= 90
	var tween=create_tween()
	tween.tween_property($filter_base, "rotation",  deg_to_rad(CurrentRotation), .3)
	#prevents player from turning the wheel mid-rotation since turning before tween is finsihed will cause it to turn 90 degrees from the wrong orientation 
	#and the colors on the wheels won't be in their intended positions (top, bottom, left, right)
	await tween.finished
	right_button.disabled=false

#function for detecting what color is at the top of the wheel (the selected filter) 
func _on_selector_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	var lens_color
	#the top of the wheel has an area 2D that detects what color is at the top position and passes that color to the "lens change" function to apply the corresponding filter
	if area.name=="white":
		lens_color="white"
		lens_change(lens_color)
	if area.name=="blue":
		if correct_color==area.name:
			f_image.visible=true
		else:
			f_image.visible=false
			lens_color="blue"
			lens_change(lens_color)
	if area.name=="red":
		if correct_color==area.name:
			f_image.visible=true
		else:
			f_image.visible=false
			lens_color="red"
			lens_change(lens_color)
	if area.name=="green":
		if correct_color==area.name:
			f_image.visible=true
		else:
			f_image.visible=false
			lens_color="green"
			lens_change(lens_color)

#function for displaying the filter color 
func lens_change(lens_color: String):
	
	if lens_color=="white":
		lens.visible=false
		filter_letter.texture=ImageTexture.create_from_image(N)
	if lens_color=="blue":
		lens.visible=true
		lens.texture=ImageTexture.create_from_image(blue_filter)
		filter_letter.texture=ImageTexture.create_from_image(B)
	if lens_color=="red":
		lens.visible=true
		lens.texture=ImageTexture.create_from_image(red_filter)
		filter_letter.texture=ImageTexture.create_from_image(R)
		
	if lens_color=="green":
		lens.visible=true
		lens.texture=ImageTexture.create_from_image(green_filter)
		filter_letter.texture=ImageTexture.create_from_image(G)

#function for turning 
func _on_filter_base_button_pressed() -> void:
	filter_base_button.disabled=true
	print ("button clicked")
	#turns wheel 90 degrees to the left from its current orientation	
	var CurrentRotation=$filter_base.rotation_degrees
	CurrentRotation-= 90
	var tween=create_tween()
	tween.tween_property($filter_base, "rotation",  deg_to_rad(CurrentRotation), .3)
	#prevents player from turning the wheel mid-rotation since turning before tween is finsihed will cause it to turn 90 degrees from the wrong orientation 
	#and the colors on the wheels won't be in their intended positions (top, bottom, left, right)
	await tween.finished
	filter_base_button.disabled=false
