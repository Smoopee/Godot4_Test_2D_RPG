extends "res://scripts/TurnBased/Enemy/tb_enemy_parent.gd"

@onready var tb_enemy = $"."

var game_state

func _on_tree_entered():
	enemy_stats_resource 
	set_stats(enemy_stats_resource)
	game_state = get_tree().get_nodes_in_group("game_state_tracker")

func attack_ai(targets):
	var rng = RandomNumberGenerator.new()
	var random = rng.randi_range(0, targets.size()-1)
	
	
	var start_pos = global_position
	var end_pos = targets[1].global_position - start_pos
	var tween = create_tween()
	
	for i in targets:
		if i.is_dodging == false:
			i.change_health(-stats.attack)
			print("minotaur_tb: hits targets for " + str(-stats.attack))

	tween.tween_property(tb_enemy, "position", end_pos, 1.5)
	tween.tween_property(tb_enemy, "position", start_pos - global_position, .5)
	await tween.finished
	game_state[0].end_turn()
