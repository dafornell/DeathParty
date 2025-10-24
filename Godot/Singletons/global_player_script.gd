extends Node
@warning_ignore_start("unused_signal")
# Player emits their location
signal player_moved(position: Vector3)

# Signal whether and where to spawn the follower npc
signal spawn_follower_npc(should_spawn: bool, g_position: Vector3)

signal update_cells()
@warning_ignore_restore("unused_signal")
