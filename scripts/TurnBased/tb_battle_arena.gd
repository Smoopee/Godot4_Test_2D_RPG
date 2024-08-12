extends Control



func _on_tree_entered():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func tree_is_leaving():
	await get_tree().create_timer(1).timeout
	queue_free()

