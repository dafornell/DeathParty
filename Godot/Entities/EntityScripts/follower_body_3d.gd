extends CharacterBody3D
class_name FollowerBody3D

@export var movement_speed: float = 2.1
@export var navigation_agent: NavigationAgent3D
@export var model: Node3D
@export var animation_tree: AnimationTree

var player_position: Vector3
var sprint_distance_squared: float = 35.
var blend_speed: float = 8.

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
	print(global_position.distance_squared_to(player_position))
	if(global_position.distance_squared_to(player_position) > sprint_distance_squared):
		run_scale = 1.7
	
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
		change_blend_position(delta, 0)
	else:
		model.look_at(player_position, Vector3.UP, true)
		var npc_to_player: Vector3 = global_position.direction_to(player_position)
		var npc_to_movement_direction: Vector3 = global_position.direction_to(global_position+velocity)
		if npc_to_player.angle_to(npc_to_movement_direction) < PI/2:
			change_blend_position(delta, 1)
		else:
			change_blend_position(delta, -1)

func change_blend_position(delta: float, blend_to: float) -> void:
	var blend_position: float = animation_tree["parameters/BlendSpace1D/blend_position"]
	blend_position = lerpf(blend_position, blend_to, blend_speed * delta)
	animation_tree["parameters/BlendSpace1D/blend_position"] = blend_position
