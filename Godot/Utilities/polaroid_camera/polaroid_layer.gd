class_name PolaroidLayer extends CanvasLayer


@export var viewfinder_camera: Camera2D

# variable hold the image that the camera is looking at  
@export var Picture: TextureRect
@export var shoot:Button
# takes in picture count 
var count =0

func _ready() -> void:
	Globals.polaroid_camera_ui = self

# function for movement of camera
func _physics_process(delta) -> void:
	# picture movement corresponds with player input	
	#if (Picture!=""):	
		# counts the first E when opening the picture taking scene, so have to
		# shoot on the second picture take input	
		if self.visible and Input.is_action_just_pressed("take_picture"):
			count+=1
			if count ==2:
				shoot.pressed.emit()
		if Input.is_action_pressed("move_right"):
			Picture.position.x -= 3
		if Input.is_action_pressed("move_left"):
			Picture.position.x += 3
		if Input.is_action_pressed("move_down"):
			Picture.position.y -= 3
		if Input.is_action_pressed("move_up"):
			Picture.position.y += 3

	# keeps image within the bounds 
		if Picture.position.x > 0:
			Picture.position.x =0

		if Picture.position.x < -(Picture.size.x*Picture.scale.x-get_viewport().size.x):
			Picture.position.x = -(Picture.size.x*Picture.scale.x-get_viewport().size.x)

		if Picture.position.y > 0:
			Picture.position.y = 0

		if Picture.position.y < -(Picture.size.y*Picture.scale.y-get_viewport().size.y):
			Picture.position.y = -(Picture.size.y*Picture.scale.y-get_viewport().size.y)

#this function need to be called first to set the picture being taken 
func start(picture: String,filter: String,filter_picture:String):
	#var image = Image.load_from_file(picture)
	$body/MainImage.texture=load(picture)
	Picture=$body/MainImage
#	calls function that takes in the filtered image and the associated filter color
	$body/MainImage.visible=true
	self.visible=true
	
#ignore this function. Was used previously to open the picture taking scene
func _on_question_mark_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	# detects when player clicks on question mark
	if event is InputEventMouseButton:
		# pops up picture taking scene and switch to 2D camera	
		$body/MainImage/Camera2D.enabled=true
		$body/MainImage/Camera2D.make_current()
		visible=true	
