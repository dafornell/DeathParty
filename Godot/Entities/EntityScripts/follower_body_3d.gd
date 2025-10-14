extends CharacterBody3D
class_name FollowerBody3D

@export var movement_speed: float = 2.1
@export var run_multiplier: float = 1.5
@export var navigation_agent: NavigationAgent3D
@export var model: Node3D
@export var animation_tree: AnimationTree

var player_position: Vector3
var sprint_distance_squared: float = 30
var blend_speed: float = 8.
var is_sprinting: bool = false

func _ready() -> void:
	if(navigation_agent):
		navigation_agent.velocity_computed.connect(Callable(_on_velocity_computed))
		GlobalPlayerScript.player_moved.connect(_move_to_player)

func set_movement_target(movement_target: Vector3) -> void:
	navigation_agent.set_target_position(movement_target)

func _physics_process(delta: float) -> void:
	if(!navigation_agent):
		return
	animate_npc(delta)
	
	# Do not query when the map has never synchronized and is empty.
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		return
	
	var run_scale: float = 1
	is_sprinting = false
	if(global_position.distance_squared_to(player_position) > sprint_distance_squared):
		run_scale = run_multiplier
		is_sprinting = true
	
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * movement_speed * run_scale
	apply_floor_snap() # Keep follower on ground
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	move_and_slide()

func _move_to_player(player_pos: Vector3) -> void:
	player_position = player_pos
	set_movement_target(player_pos)

func animate_npc(delta: float) -> void:
	assert(model, "Model not instantiated!")
	assert(animation_tree, "Animation Tree not instantiated!")
	if velocity == Vector3.ZERO:
		change_blend_position(delta, 0, 0)
		return
	
	## If velocity is not 0
	var npc_to_player: Vector3 = global_position.direction_to(player_position)
	var npc_to_movement_direction: Vector3 = global_position.direction_to(global_position+velocity)
	
	model.look_at(player_position, Vector3.UP, true)
	if npc_to_player.angle_to(npc_to_movement_direction) < PI/2:
		# Moves forward
		if is_sprinting:
			change_blend_position(delta, 0, 1)
		else:
			change_blend_position(delta, 1, 0)
	else:
		# Moves backward
		change_blend_position(delta, -1, 0)

func change_blend_position(delta: float, blend_x_to: float, blend_y_to: float) -> void:
	var blend_position_x: float = animation_tree["parameters/BlendSpace2D/blend_position"].x
	var blend_position_y: float = animation_tree["parameters/BlendSpace2D/blend_position"].y
	blend_position_x = lerpf(blend_position_x, blend_x_to, blend_speed * delta)
	blend_position_y = lerpf(blend_position_y, blend_y_to, blend_speed * delta)
	animation_tree["parameters/BlendSpace2D/blend_position"].x = blend_position_x
	animation_tree["parameters/BlendSpace2D/blend_position"].y = blend_position_y
