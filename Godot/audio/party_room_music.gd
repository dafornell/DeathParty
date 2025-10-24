extends FmodEventEmitter3D


func _on_stopped() -> void:
	# this emitter has autoplay enabled so it should always loop, but sometimes
	# it seems to stop looping for some reason - this is an attempt to force it
	# to play (no idea if it will do anything lol)
	play()


func _on_start_failed() -> void:
	print("failed to start party room music")
	print("trying to play again . . .")
	play()
