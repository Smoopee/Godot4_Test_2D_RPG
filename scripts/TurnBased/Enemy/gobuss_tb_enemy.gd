extends "res://scripts/TurnBased/Enemy/tb_enemy_parent.gd"

@onready var tb_enemy = $"."

var game_state


func _on_tree_entered():
	enemy_stats_resource 
	#= load("res://resources/tb_resources/Enemies/gobuss.tres")
	set_stats(enemy_stats_resource)
	game_state = get_tree().get_nodes_in_group("game_state_tracker")


func attack_ai(targets):
	print("Enemy targets are " + str(targets))
	var rng = RandomNumberGenerator.new()
	var random = rng.randi_range(0, targets.size()-1)
	print("Random number is: " + str(random))
	var enemy_target = targets[random]
	
	var tween = create_tween()
	var start_pos = global_position
	var end_pos = enemy_target.global_position - start_pos 
	
	print("gobuss_tb: global position is " + str(global_position))
	print("gobuss_tb: Enemy position is " + str(enemy_target.global_position))
	
	if enemy_target.is_dodging == false:
		enemy_target.change_health(-stats.attack)
	
	print("gobuss_tb: game_state[0] is  " + str(game_state[0]))
	tween.tween_property(tb_enemy, "position", end_pos, 1.5)
	tween.tween_property(tb_enemy, "position", start_pos - global_position, .5)
	await tween.finished
	game_state[0].end_turn()
