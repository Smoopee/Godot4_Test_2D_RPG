extends Area2D

func _on_body_entered(body):
	
	
	if body.is_in_group("player"):
		
		var rng = RandomNumberGenerator.new()
		var random_chance_encounter = rng.randi_range(1,10)
		
		if random_chance_encounter > 8:
			get_tree().change_scene_to_file("res://scenes/TBScenes/tb_battle_arena.tscn")
