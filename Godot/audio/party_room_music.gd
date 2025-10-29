extends FmodEventEmitter3D


func _on_stopped() -> void:
	# this emitter has autoplay enabled so it should always loop, but sometimes
	# it seems to stop looping for some reason - this is an attempt to force it
	# to play (no idea if it will do anything lol)
	play()


func _on_start_failed() -> void:
	# NOTE: i put a breakpoint here and it didnt get reached when the music
	# 		failed to loop so it seems like play() isnt getting called at all
	#		when the player is too far away from the emitter
	push_error("failed to start party room music")
	play()
