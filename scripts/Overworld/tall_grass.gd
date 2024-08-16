extends Area2D

@onready var scene_transition_animation = $sceneTransitionAnimation/AnimationPlayer
@onready var overworld_1 = $"../.."


var encounter_cooldown: bool = true
signal side_scene_finished

# In the main scene root script


# Connect to a signal on the canvas layer to be able to detect when
# the side scene is removed so we can re-enable the main scene.
func _on_SideSceneLayer_child_exiting_tree(_node: Node) -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	side_scene_finished.emit() # Maybe some objects want to know when we just came back

func _on_body_entered(body):
	if body.is_in_group("player") and encounter_cooldown == true:
		encounter_cooldown == false
		var rng = RandomNumberGenerator.new()
		var random_chance_encounter = rng.randi_range(1,10)
		
		if random_chance_encounter > 8:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			scene_transition_animation.play("fade_in")
			await get_tree().create_timer(1).timeout
			scene_transition_animation.stop()
			var new_combat = preload("res://scenes/TBScenes/tb_battle_arena.tscn").instantiate()
			get_parent().get_parent().show_side_scene(new_combat)


# In player or detector script or whatever


func _on_side_scene_finished():
	pass # Replace with function body.
